import 'dart:convert';
import 'package:flutter/material.dart';
import '../../metadata/record_metadata.dart';
import '../../services/backend_service.dart';
import '../../services/navigator_service.dart';
import 'record_action_runner.dart';
import 'record_action_sheet.dart';
import 'record_detail_screen.dart';

class RecordItemHandler {
  const RecordItemHandler._();

  static Future<void> handleTap(
    BuildContext context, {
    required RecordSchemaMetadata schema,
    required Map<String, dynamic> record,
    String? nodeId,
    String? itemClickAction,
    String? itemClickTarget,
    String? itemClickFields,
    Future<dynamic> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
    required VoidCallback onRefresh,
  }) async {
    final childActions = (nodeId != null && nodeId.isNotEmpty)
        ? NavigatorService.instance.getChildActions(nodeId)
        : <Map<String, dynamic>>[];

    if (childActions.isNotEmpty) {
      RecordActionRunner.showChildActionsSheet(
        context,
        schema: schema,
        record: record,
        actions: childActions,
        onExecuteAction: onExecuteAction,
        onRefresh: onRefresh,
      );
      return;
    }

    final action = itemClickAction?.toUpperCase();
    if (action == 'BOTTOM_SHEET_FORM') {
      List<RecordFieldMetadata> formFields = [];
      if (itemClickFields != null && itemClickFields.isNotEmpty) {
        try {
          final decoded = jsonDecode(itemClickFields) as List;
          formFields = decoded
              .map((f) => RecordFieldMetadata.fromJson(Map<String, dynamic>.from(f as Map)))
              .toList();
        } catch (e) {
          debugPrint('Error parsing itemClickFields JSON: $e');
        }
      }

      if (formFields.isEmpty) {
        formFields = schema.fields.where((f) => !f.isKey).take(3).toList();
      }

      final targetAction = itemClickTarget ?? 'Submit';

      RecordActionSheet.show(
        context,
        title: targetAction,
        actionLabel: 'Submit',
        fields: formFields,
        initialValues: record,
        onSubmit: (values) async {
          final payload = <String, dynamic>{...record, ...values};
          if (onExecuteAction != null) {
            await onExecuteAction(targetAction, payload);
          } else {
            await BackendService.instance.executeAction(
              projection: schema.projection,
              actionName: targetAction,
              parameters: payload,
            );
          }
          onRefresh();
        },
      );
      return;
    }

    await openDetail(
      context,
      schema: schema,
      record: record,
      onExecuteAction: onExecuteAction,
      onRefresh: onRefresh,
    );
  }

  static Future<void> openDetail(
    BuildContext context, {
    required RecordSchemaMetadata schema,
    required Map<String, dynamic> record,
    Future<dynamic> Function(String actionName, Map<String, dynamic> data)? onExecuteAction,
    required VoidCallback onRefresh,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordDetailScreen(
          schema: schema,
          record: record,
          onExecuteAction: onExecuteAction,
        ),
      ),
    );
    onRefresh();
  }
}
