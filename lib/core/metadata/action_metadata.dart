import 'package:flutter/foundation.dart';

enum ActionType {
  navigate,
  openDialog,
  openUrl,
  custom,
}

@immutable
class ActionMetadata {
  final ActionType type;
  final String target;
  final Map<String, dynamic> params;

  const ActionMetadata({
    required this.type,
    required this.target,
    this.params = const {},
  });

  factory ActionMetadata.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'navigate';
    final actionType = ActionType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => ActionType.navigate,
    );

    return ActionMetadata(
      type: actionType,
      target: json['target'] as String? ?? '',
      params: (json['params'] as Map<String, dynamic>?) ?? const {},
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'target': target,
        'params': params,
      };
}
