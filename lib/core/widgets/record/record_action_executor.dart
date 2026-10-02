import 'package:flutter/material.dart';
import '../../metadata/action_param_metadata.dart';
import '../../metadata/entity_metadata.dart';
import '../../network/data_query.dart';
import '../../services/backend_service.dart';
import '../../services/schema_catalog_service.dart';
import '../../utils/param_config_parser.dart';
import '../../utils/payload_utils.dart';
import '../../utils/record_display_utils.dart';
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
    List<Map<String, dynamic>> rawParams = [];
    try {
      rawParams = await BackendService.instance.fetchEntitySet(
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

    final (defaults, hiddenFields, explicitFields, mandatoryFields, optionalFields) = ParamConfigParser.parse(paramConfig);
    if (explicitFields.isNotEmpty) {
      formFields = explicitFields;
    } else {
      // 1. Group dot-notated parameters (e.g. ReqLines.PartNo) into parent structure field (ReqLines)
      final topLevelFields = <String, EntityFieldMetadata>{};
      final nestedMap = <String, List<EntityFieldMetadata>>{};

      for (final f in formFields) {
        if (f.key.contains('.')) {
          final parts = f.key.split('.');
          final parentKey = parts[0];
          final childKey = parts.sublist(1).join('.');
          
          final childField = f.copyWith(
            key: childKey,
            label: RecordDisplayUtils.formatLabel(childKey),
            isRequired: mandatoryFields.contains(f.key.toUpperCase())
                ? true
                : (optionalFields.contains(f.key.toUpperCase()) ? false : f.isRequired),
          );

          nestedMap.putIfAbsent(parentKey, () => []).add(childField);
        } else {
          final isReq = mandatoryFields.contains(f.key.toUpperCase())
              ? true
              : (optionalFields.contains(f.key.toUpperCase()) ? false : f.isRequired);
          topLevelFields[f.key] = f.copyWith(isRequired: isReq);
        }
      }

      // Merge nested fields into parent
      final consolidated = <EntityFieldMetadata>[];
      for (final entry in topLevelFields.entries) {
        var parentField = entry.value;
        if (nestedMap.containsKey(parentField.key)) {
          final children = nestedMap[parentField.key]!;
          // Filter children that are hidden
          final visibleChildren = children
              .where((c) => !hiddenFields.contains('${parentField.key}.${c.key}'.toUpperCase()) &&
                            !hiddenFields.contains(c.key.toUpperCase()))
              .toList();
          parentField = parentField.copyWith(
            nestedFields: visibleChildren,
            type: FieldType.array,
          );
        }
        consolidated.add(parentField);
      }

      formFields = consolidated;

      // 2. Filter top-level hidden fields
      if (hiddenFields.isNotEmpty) {
        formFields = formFields.where((f) => !hiddenFields.contains(f.key.toUpperCase())).toList();
      }
    }

    // Retain full schema definitions (including all child structure fields) for serialization
    final allFieldDefinitions = <EntityFieldMetadata>[];
    final allTopLevel = <String, EntityFieldMetadata>{};
    final allNested = <String, List<EntityFieldMetadata>>{};
    for (final f in formFields) {
      allTopLevel[f.key] = f;
    }
    // Also include rawParams fields if not present
    for (final f in rawParams.map((p) => ActionParamMetadata.fromJson(p).toFormField(projection: projection))) {
      if (f.key.contains('.')) {
        final parts = f.key.split('.');
        allNested.putIfAbsent(parts[0], () => []).add(f.copyWith(key: parts.sublist(1).join('.')));
      } else {
        allTopLevel.putIfAbsent(f.key, () => f);
      }
    }
    for (final entry in allTopLevel.entries) {
      var field = entry.value;
      if (allNested.containsKey(field.key)) {
        field = field.copyWith(
          nestedFields: allNested[field.key]!,
          type: FieldType.array,
        );
      }
      allFieldDefinitions.add(field);
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

    final initialVals = <String, dynamic>{
      for (final entry in defaults.entries)
        if (!entry.key.contains('.')) entry.key: entry.value,
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
