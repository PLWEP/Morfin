import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../metadata/action_param_metadata.dart';
import '../../metadata/entity_metadata.dart';
import '../../network/data_query.dart';
import '../../services/backend_service.dart';
import '../../services/schema_catalog_service.dart';
import 'record_action_sheet.dart';

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
      final payload = sanitizePayload(record);
      if (onExecuteAction != null) {
        await onExecuteAction(actionName, payload);
      } else {
        await BackendService.instance.executeAction(
          projection: projection,
          actionName: actionName,
          parameters: payload,
        );
      }
      messenger.showSnackBar(
        SnackBar(content: Text('"$label" completed successfully'), behavior: SnackBarBehavior.floating),
      );
      onRefresh();
    } catch (e) {
      final errorMsg = extractErrorMessage(e);
      messenger.showSnackBar(
        SnackBar(content: Text('Error: $errorMsg'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
      );
    }
  }

  static Future<void> triggerFormAction(
    BuildContext context, {
    required EntitySchemaMetadata schema,
    required Map<String, dynamic> record,
    required String title,
    required String projection,
    required String actionName,
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
        query: DataQuery(
          filter: "ProjectionName eq '$projection' and ActionName eq '$actionName'",
        ),
      );

      if (rawParams.isNotEmpty) {
        formFields = rawParams
            .map((p) => ActionParamMetadata.fromJson(p).toFormField(projection: projection))
            .toList();
      } else {
        formFields = await SchemaCatalogService.instance.fetchActionFields(
          projection: projection,
          actionName: actionName,
        );
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

    if (formFields.isEmpty) {
      formFields = schema.fields.where((f) => !f.isKey).take(4).toList();
    }

    if (!context.mounted) return;

    RecordActionSheet.show(
      context,
      title: title,
      actionLabel: 'Submit',
      fields: formFields,
      initialValues: record,
      onSubmit: (values) async {
        final payload = sanitizePayload(<String, dynamic>{...record, ...values});
        try {
          if (onExecuteAction != null) {
            await onExecuteAction(actionName, payload);
          } else {
            await BackendService.instance.executeAction(
              projection: projection,
              actionName: actionName,
              parameters: payload,
            );
          }
          messenger.showSnackBar(
            SnackBar(content: Text('"$title" submitted successfully'), behavior: SnackBarBehavior.floating),
          );
          onRefresh();
        } catch (e) {
          final errorMsg = extractErrorMessage(e);
          messenger.showSnackBar(
            SnackBar(content: Text('Error: $errorMsg'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
          );
        }
      },
    );
  }

  static Map<String, dynamic> sanitizePayload(Map<String, dynamic> raw) {
    const internalKeys = {'luname', 'objid', 'objversion', 'rowkey', 'rowstate', 'rowtype'};
    final cleaned = <String, dynamic>{};
    for (final entry in raw.entries) {
      final k = entry.key;
      if (!k.startsWith('@') && !internalKeys.contains(k.toLowerCase())) {
        cleaned[k] = entry.value;
      }
    }
    return cleaned;
  }

  static String extractErrorMessage(dynamic error) {
    if (error is DioException && error.response?.data is Map) {
      final map = error.response!.data as Map;
      final err = map['error'];
      if (err is Map && err['message'] != null) {
        return err['message'].toString();
      }
    }
    return error.toString();
  }
}
