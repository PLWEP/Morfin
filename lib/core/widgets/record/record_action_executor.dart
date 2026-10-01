import 'dart:convert';
import 'package:flutter/material.dart';
import '../../metadata/action_param_metadata.dart';
import '../../metadata/entity_metadata.dart';
import '../../network/data_query.dart';
import '../../services/backend_service.dart';
import '../../services/schema_catalog_service.dart';
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

    final (defaults, hiddenFields, explicitFields) = _parseParamConfig(paramConfig);
    if (explicitFields.isNotEmpty) {
      formFields = explicitFields;
    } else if (hiddenFields.isNotEmpty) {
      formFields = formFields.where((f) => !hiddenFields.contains(f.key.toUpperCase())).toList();
    }

    if (formFields.isEmpty) {
      formFields = schema.fields.where((f) => !f.isKey && !hiddenFields.contains(f.key.toUpperCase())).take(4).toList();
    }

    formFields = formFields.map((f) {
      final updatedNested = f.nestedFields.map((nf) => nf.lovProjection == null ? nf.copyWith(lovProjection: projection) : nf).toList();
      return f.copyWith(
        lovProjection: f.lovProjection ?? projection,
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

  static (Map<String, dynamic>, Set<String>, List<EntityFieldMetadata>) _parseParamConfig(String? cfg) {
    if (cfg == null || cfg.isEmpty) return (const {}, const {}, const []);
    final defaults = <String, dynamic>{};
    final hidden = <String>{};
    final explicit = <EntityFieldMetadata>[];

    final trimmed = cfg.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        final decoded = jsonDecode(trimmed) as Map<String, dynamic>;
        if (decoded.containsKey('fields') && decoded['fields'] is List) {
          final fieldsList = decoded['fields'] as List;
          for (final f in fieldsList) {
            if (f is Map) {
              explicit.add(EntityFieldMetadata.fromJson(Map<String, dynamic>.from(f)));
            }
          }
        }
        if (decoded.containsKey('defaults') && decoded['defaults'] is Map) {
          defaults.addAll(Map<String, dynamic>.from(decoded['defaults'] as Map));
        }
        if (decoded.containsKey('hide') && decoded['hide'] is List) {
          hidden.addAll((decoded['hide'] as List).map((e) => e.toString().toUpperCase()));
        }
        return (defaults, hidden, explicit);
      } catch (_) {}
    }

    for (final token in cfg.split('^')) {
      final t = token.trim();
      if (t.isEmpty) continue;
      final eq = t.indexOf('=');
      if (eq <= 0) continue;
      final k = t.substring(0, eq).trim();
      final v = t.substring(eq + 1).trim();
      if (k.toUpperCase() == 'HIDE') {
        hidden.addAll(v.split(',').map((s) => s.trim().toUpperCase()));
      } else {
        defaults[k] = v;
      }
    }
    return (defaults, hidden, explicit);
  }

  static Map<String, dynamic> sanitizePayload(Map<String, dynamic> raw) => PayloadUtils.sanitize(raw);
  static String extractErrorMessage(dynamic error) => PayloadUtils.extractErrorMessage(error);
}
