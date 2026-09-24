import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'work_order_contract.dart';
import 'work_order_mock_data.dart';

class WorkOrderNotifier extends Notifier<WorkOrderState> {
  @override
  WorkOrderState build() => const WorkOrderState(items: WorkOrderMockData.items);

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleChecklist(String orderId, String checklistId) {
    final updatedItems = state.items.map((order) {
      if (order.id != orderId) return order;
      final updatedChecklist = order.checklist.map((c) {
        if (c.id != checklistId) return c;
        return c.copyWith(isDone: !c.isDone);
      }).toList();
      return order.copyWith(checklist: updatedChecklist);
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void updateStatus(String orderId, WorkOrderStatus newStatus) {
    final updatedItems = state.items.map((order) {
      if (order.id != orderId) return order;
      return order.copyWith(status: newStatus);
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void addWorkOrder({
    required String title,
    required String assetName,
    required String location,
    required WorkOrderPriority priority,
    required String dueDate,
    required String description,
  }) {
    final nextNum = state.items.length + 1;
    final newOrder = WorkOrder(
      id: 'wo-$nextNum',
      code: 'WO-${8900 + nextNum}',
      title: title,
      assetName: assetName,
      location: location,
      priority: priority,
      status: WorkOrderStatus.pending,
      assignedTo: 'You',
      dueDate: dueDate,
      description: description,
      checklist: const [
        WorkOrderChecklist(id: 'c1', label: 'Initial site assessment', isDone: false),
        WorkOrderChecklist(id: 'c2', label: 'Perform diagnostic and maintenance', isDone: false),
        WorkOrderChecklist(id: 'c3', label: 'Final validation and signoff', isDone: false),
      ],
    );
    state = state.copyWith(items: [newOrder, ...state.items]);
  }

  WorkOrder? getOrderById(String id) {
    try {
      return state.items.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}

final workOrderProvider = NotifierProvider<WorkOrderNotifier, WorkOrderState>(
  WorkOrderNotifier.new,
);
