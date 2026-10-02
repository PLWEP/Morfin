import 'package:flutter/material.dart';
import '../../metadata/action_param_metadata.dart';
import '../../metadata/entity_metadata.dart';
import '../../network/data_query.dart';
import '../../services/backend_service.dart';
import '../../services/schema_catalog_service.dart';
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

    List<EntityFieldMetadata> formFields = [];
    try {
      final rawParams = await BackendService.instance.fetchEntitySet(
        projection: 'MobileNavMenuHandling',
        entitySet: 'ActionParamSet',
        query: DataQuery(filter: "ProjectionName eq '$projection' and ActionName eq '$actionName'"),
      );

      if (rawParams.isNotEmpty) {
        formFields = rawParams.map((p) => ActionParamMetadata.fromJson(p).toFormField(projection: projection)).toList();
      } else {
        formFields = await SchemaCatalogService.instance.fetchActionFields(projection: projection, actionName: actionName);
        if (formFields.isEmpty) {
          formFields = await SchemaCatalogService.instance.fetchRecordFields(
            projection: projection,
            entitySetOrName: schema.entitySet.isNotEmpty ? schema.entitySet : actionName,
          );
        }
      }
    } catch (e) {
      debugPrint('Failed to load action metadata: $e');
    } finally {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    }

    final (defaults, hiddenFields, explicitFields) = ParamConfigParser.parse(paramConfig);
    if (explicitFields.isNotEmpty) {
      formFields = explicitFields;
    } else if (hiddenFields.isNotEmpty) {
      formFields = formFields.where((f) => !hiddenFields.contains(f.key.toUpperCase())).toList();
    }

    if (formFields.isEmpty) {
      formFields = schema.fields.where((f) => !f.isKey && !hiddenFields.contains(f.key.toUpperCase())).take(4).toList();
    }

    final effectiveProj = projection.replaceAll('/', '').trim();

    formFields = formFields.map((f) {
      final updatedNested = f.nestedFields.map((nf) {
        final nestedProj = (nf.lovProjection == null || nf.lovProjection!.isEmpty) ? effectiveProj : nf.lovProjection;
        return nf.copyWith(lovProjection: nestedProj);
      }).toList();

      final fieldProj = (f.lovProjection == null || f.lovProjection!.isEmpty) ? effectiveProj : f.lovProjection;
      return f.copyWith(
        lovProjection: fieldProj,
        nestedFields: updatedNested,
      );
    }).toList();

    if (!context.mounted) return;

    if (formFields.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text('No parameters or fields found for "$title"'), behavior: SnackBarBehavior.floating));
      return;
    }

    final initialVals = <String, dynamic>{...defaults, ...record};

    if (isFullScreen) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecordFormScreen(
            title: title,
            projection: projection,
            actionName: actionName,
            fields: formFields,
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
      fields: formFields,
      initialValues: initialVals,
      onSubmit: (values) async {
        final payload = PayloadUtils.sanitize(<String, dynamic>{...defaults, ...record, ...values});
        try {
          if (onExecuteAction != null) {
            await onExecuteAction(actionName, payload);
          } else {
            await BackendService.instance.executeAction(projection: projection, actionName: actionName, parameters: payload);
          }
          messenger.showSnackBar(SnackBar(content: Text('"$title" submitted successfully'), behavior: SnackBarBehavior.floating));
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
