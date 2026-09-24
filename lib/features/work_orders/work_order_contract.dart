import 'package:flutter/material.dart';

enum WorkOrderStatus {
  pending('Pending', Icons.schedule_rounded),
  inProgress('In Progress', Icons.autorenew_rounded),
  completed('Completed', Icons.check_circle_outline_rounded);

  final String label;
  final IconData icon;
  const WorkOrderStatus(this.label, this.icon);
}

enum WorkOrderPriority {
  low('Low'),
  medium('Medium'),
  high('High'),
  urgent('Urgent');

  final String label;
  const WorkOrderPriority(this.label);
}

class WorkOrderChecklist {
  final String id;
  final String label;
  final bool isDone;

  const WorkOrderChecklist({
    required this.id,
    required this.label,
    this.isDone = false,
  });

  WorkOrderChecklist copyWith({bool? isDone}) {
    return WorkOrderChecklist(id: id, label: label, isDone: isDone ?? this.isDone);
  }

  Map<String, dynamic> toJson() => {'id': id, 'label': label, 'isDone': isDone};

  factory WorkOrderChecklist.fromJson(Map<String, dynamic> json) => WorkOrderChecklist(
        id: json['id'] as String? ?? '',
        label: json['label'] as String? ?? '',
        isDone: json['isDone'] as bool? ?? false,
      );
}

class WorkOrder {
  final String id;
  final String code;
  final String title;
  final String assetName;
  final String location;
  final WorkOrderPriority priority;
  final WorkOrderStatus status;
  final String assignedTo;
  final String dueDate;
  final String description;
  final List<WorkOrderChecklist> checklist;

  const WorkOrder({
    required this.id,
    required this.code,
    required this.title,
    required this.assetName,
    required this.location,
    required this.priority,
    required this.status,
    required this.assignedTo,
    required this.dueDate,
    required this.description,
    required this.checklist,
  });

  int get completedChecklistCount => checklist.where((c) => c.isDone).length;

  WorkOrder copyWith({WorkOrderStatus? status, List<WorkOrderChecklist>? checklist}) {
    return WorkOrder(
      id: id,
      code: code,
      title: title,
      assetName: assetName,
      location: location,
      priority: priority,
      status: status ?? this.status,
      assignedTo: assignedTo,
      dueDate: dueDate,
      description: description,
      checklist: checklist ?? this.checklist,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id, 'code': code, 'title': title, 'assetName': assetName,
        'location': location, 'priority': priority.name, 'status': status.name,
        'assignedTo': assignedTo, 'dueDate': dueDate, 'description': description,
        'checklist': checklist.map((c) => c.toJson()).toList(),
      };

  factory WorkOrder.fromJson(Map<String, dynamic> json) => WorkOrder(
        id: json['id'] as String? ?? '',
        code: json['code'] as String? ?? '',
        title: json['title'] as String? ?? '',
        assetName: json['assetName'] as String? ?? '',
        location: json['location'] as String? ?? '',
        priority: WorkOrderPriority.values.firstWhere((p) => p.name == json['priority'], orElse: () => WorkOrderPriority.medium),
        status: WorkOrderStatus.values.firstWhere((s) => s.name == json['status'], orElse: () => WorkOrderStatus.pending),
        assignedTo: json['assignedTo'] as String? ?? '',
        dueDate: json['dueDate'] as String? ?? '',
        description: json['description'] as String? ?? '',
        checklist: (json['checklist'] as List<dynamic>? ?? [])
            .map((c) => WorkOrderChecklist.fromJson(c as Map<String, dynamic>))
            .toList(),
      );
}

@immutable
class WorkOrderState {
  final List<WorkOrder> items;
  final String selectedFilter;
  final String searchQuery;

  const WorkOrderState({
    this.items = const [],
    this.selectedFilter = 'all',
    this.searchQuery = '',
  });

  List<WorkOrder> get filteredItems {
    return items.where((item) {
      final matchesFilter = switch (selectedFilter) {
        'pending' => item.status == WorkOrderStatus.pending,
        'inProgress' => item.status == WorkOrderStatus.inProgress,
        'completed' => item.status == WorkOrderStatus.completed,
        _ => true,
      };

      final matchesQuery = searchQuery.isEmpty ||
          item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.assetName.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesQuery;
    }).toList();
  }

  WorkOrderState copyWith({
    List<WorkOrder>? items,
    String? selectedFilter,
    String? searchQuery,
  }) {
    return WorkOrderState(
      items: items ?? this.items,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
