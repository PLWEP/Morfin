import 'package:flutter/material.dart';
import '../../metadata/entity_metadata.dart';
import '../../services/backend_service.dart';
import '../../utils/action_field_consolidator.dart';
import '../../utils/action_metadata_loader.dart';
import '../../utils/param_config_parser.dart';
import '../../utils/payload_utils.dart';
import 'record_action_sheet.dart';
import 'record_form_screen.dart';

class RecordActionExecutor {
  const RecordActionExecutor._();

  static Future<void> triggerDirectAction(
    BuildContext context, {
    required String label,
    required Map<String, dynamic> record,
    required String projection,
    required String actionName,
    Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
    required VoidCallback onRefresh,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Execute $label?'),
        content: Text('Are you sure you want to execute "$label"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Execute')),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final payload = PayloadUtils.sanitize(record);
      if (onExecuteAction != null) {
        await onExecuteAction(actionName, payload);
      } else {
        await BackendService.instance.executeAction(projection: projection, actionName: actionName, parameters: payload);
      }
      messenger.showSnackBar(SnackBar(content: Text('"$label" completed successfully'), behavior: SnackBarBehavior.floating));
      onRefresh();
    } catch (e) {
      final errorMsg = PayloadUtils.extractErrorMessage(e);
      messenger.showSnackBar(SnackBar(content: Text('Error: $errorMsg'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
    }
  }

  static Future<void> triggerFormAction(
    BuildContext context, {
    required EntitySchemaMetadata schema,
    required Map<String, dynamic> record,
    required String title,
    required String projection,
    required String actionName,
    String? paramConfig,
    bool isFullScreen = false,
    Future<void> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
    required VoidCallback onRefresh,
  }) async {
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final (loadedFields, rawParams) = await ActionMetadataLoader.load(
      projection: projection,
      actionName: actionName,
      schema: schema,
    );
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    List<EntityFieldMetadata> formFields = loadedFields;

    final (defaults, hiddenFields, explicitFields, mandatoryFields, optionalFields) = ParamConfigParser.parse(paramConfig);
    if (explicitFields.isNotEmpty) {
      formFields = explicitFields;
    } else {
      formFields = ActionFieldConsolidator.consolidate(
        formFields: formFields,
        mandatoryFields: mandatoryFields,
        optionalFields: optionalFields,
        hiddenFields: hiddenFields,
      );
    }

    final allFieldDefinitions = ActionFieldConsolidator.buildAllDefinitions(
      formFields: formFields,
      rawParams: rawParams,
      projection: projection,
    );

    final effectiveProj = projection.replaceAll('/', '').trim();
    formFields = formFields.map((f) {
      final updatedNested = f.nestedFields.map((nf) => nf.copyWith(
        lovProjection: (nf.lovProjection == null || nf.lovProjection!.isEmpty) ? effectiveProj : nf.lovProjection,
      )).toList();
      return f.copyWith(
        lovProjection: (f.lovProjection == null || f.lovProjection!.isEmpty) ? effectiveProj : f.lovProjection,
        nestedFields: updatedNested,
      );
    }).toList();

    if (!context.mounted) return;
    if (formFields.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text('No parameters found for "$title"'), behavior: SnackBarBehavior.floating));
      return;
    }

    final initialVals = <String, dynamic>{
      for (final entry in defaults.entries) if (!entry.key.contains('.')) entry.key: entry.value,
      ...record,
    };

    if (isFullScreen) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecordFormScreen(
            title: title,
            projection: projection,
            actionName: actionName,
            fields: formFields,
            allFieldDefinitions: allFieldDefinitions,
            paramDefaults: defaults,
            initialValues: initialVals,
            onRefresh: onRefresh,
          ),
        ),
      );
      return;
    }

    RecordActionSheet.show(
      context,
      title: title,
      actionLabel: 'Submit',
      projection: projection,
      fields: formFields,
      initialValues: initialVals,
      paramDefaults: defaults,
      onSubmit: (values) async {
        final rawCombined = <String, dynamic>{...defaults, ...record, ...values};
        final payload = PayloadUtils.formatActionPayload(
          rawValues: rawCombined,
          allFieldDefs: allFieldDefinitions,
          defaultValues: defaults,
        );
        try {
          final res = onExecuteAction != null
              ? await () async {
                  await onExecuteAction(actionName, payload);
                  return <String, dynamic>{};
                }()
              : await BackendService.instance.executeAction(projection: projection, actionName: actionName, parameters: payload);
          final msg = PayloadUtils.extractSuccessMessage(res, fallback: '"$title" submitted successfully');
          messenger.showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
          onRefresh();
        } catch (e) {
          final errorMsg = PayloadUtils.extractErrorMessage(e);
          messenger.showSnackBar(SnackBar(content: Text('Error: $errorMsg'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
        }
      },
    );
  }

  static Map<String, dynamic> sanitizePayload(Map<String, dynamic> raw) => PayloadUtils.sanitize(raw);
  static String extractErrorMessage(dynamic error) => PayloadUtils.extractErrorMessage(error);
}
