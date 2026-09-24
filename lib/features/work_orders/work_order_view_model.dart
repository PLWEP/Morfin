import 'package:flutter/material.dart';
import 'work_order_contract.dart';
import 'work_order_mock_data.dart';

class WorkOrderViewModel extends ValueNotifier<WorkOrderState> {
  WorkOrderViewModel() : super(const WorkOrderState(items: WorkOrderMockData.items));

  void setFilter(String filter) {
    value = value.copyWith(selectedFilter: filter);
  }

  void setSearchQuery(String query) {
    value = value.copyWith(searchQuery: query);
  }

  void toggleChecklist(String orderId, String checklistId) {
    final updatedItems = value.items.map((order) {
      if (order.id != orderId) return order;
      final updatedChecklist = order.checklist.map((c) {
        if (c.id != checklistId) return c;
        return c.copyWith(isDone: !c.isDone);
      }).toList();
      return order.copyWith(checklist: updatedChecklist);
    }).toList();

    value = value.copyWith(items: updatedItems);
  }

  void updateStatus(String orderId, WorkOrderStatus newStatus) {
    final updatedItems = value.items.map((order) {
      if (order.id != orderId) return order;
      return order.copyWith(status: newStatus);
    }).toList();

    value = value.copyWith(items: updatedItems);
  }

  WorkOrder? getOrderById(String id) {
    try {
      return value.items.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
