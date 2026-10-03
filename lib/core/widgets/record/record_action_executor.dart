import 'package:flutter/material.dart';
import '../../metadata/record_metadata.dart';
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
    Future<dynamic> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
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
      final res = onExecuteAction != null
          ? await onExecuteAction(actionName, payload)
          : await BackendService.instance.executeAction(projection: projection, actionName: actionName, parameters: payload);
      final msg = res is Map<String, dynamic>
          ? PayloadUtils.extractSuccessMessage(res, fallback: '"$label" completed successfully')
          : '"$label" completed successfully';
      messenger.showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
      onRefresh();
    } catch (e) {
      final errorMsg = PayloadUtils.extractErrorMessage(e);
      messenger.showSnackBar(SnackBar(content: Text('Error: $errorMsg'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
    }
  }

  static Future<void> triggerFormAction(
    BuildContext context, {
    required RecordSchemaMetadata schema,
    required Map<String, dynamic> record,
    required String title,
    required String projection,
    required String actionName,
    String? paramConfig,
    bool isFullScreen = false,
    Future<dynamic> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
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
    List<RecordFieldMetadata> formFields = loadedFields;

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
    formFields = ActionFieldConsolidator.applyLovProjection(formFields, projection);

    if (!context.mounted) return;
    if (formFields.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text('No parameters found for "$title"'), behavior: SnackBarBehavior.floating));
      return;
    }

    final initialVals = ActionFieldConsolidator.resolveInitialValues(fields: formFields, defaults: defaults, record: record);

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
              ? await onExecuteAction(actionName, payload)
              : await BackendService.instance.executeAction(projection: projection, actionName: actionName, parameters: payload);
          final resMap = res is Map<String, dynamic> ? res : <String, dynamic>{};
          final msg = PayloadUtils.extractSuccessMessage(resMap, fallback: '"$title" submitted successfully');
          messenger.showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
          onRefresh();
        } catch (e) {
          final errorMsg = PayloadUtils.extractErrorMessage(e);
          messenger.showSnackBar(SnackBar(content: Text('Error: $errorMsg'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
        }
      },
    );
  }
}
