class MobileNavNode {
  final int nodeId;
  final int? parentId;
  final String label;
  final String actionType;
  final String? icon;
  final String? targetUrl;
  final String? defaultFilter;
  final String? itemClickAction;
  final String? itemClickTarget;
  final String? itemClickFields;
  final String? columnConfig;
  final int sortOrder;
  final int childCount;

  const MobileNavNode({
    required this.nodeId,
    this.parentId,
    required this.label,
    required this.actionType,
    this.icon,
    this.targetUrl,
    this.defaultFilter,
    this.itemClickAction,
    this.itemClickTarget,
    this.itemClickFields,
    this.columnConfig,
    required this.sortOrder,
    required this.childCount,
  });

  factory MobileNavNode.fromJson(Map<String, dynamic> json) {
    return MobileNavNode(
      nodeId: (json['NodeId'] ?? json['Id'] ?? 0) as int,
      parentId: json['ParentId'] as int?,
      label: (json['Label'] ?? json['CleanLabel'] ?? '').toString(),
      actionType: (json['ActionType'] ?? '').toString(),
      icon: json['Icon'] as String?,
      targetUrl: json['TargetUrl'] as String?,
      defaultFilter: json['DefaultFilter'] as String?,
      itemClickAction: json['ItemClickAction'] as String?,
      itemClickTarget: json['ItemClickTarget'] as String?,
      itemClickFields: json['ItemClickFields'] as String?,
      columnConfig: json['ColumnConfig'] as String?,
      sortOrder: (json['SortOrder'] as num?)?.toInt() ?? 0,
      childCount: (json['ChildCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'NodeId': nodeId,
    'ParentId': parentId,
    'Label': label,
    'ActionType': actionType,
    'Icon': icon,
    'TargetUrl': targetUrl,
    'DefaultFilter': defaultFilter,
    'ItemClickAction': itemClickAction,
    'ItemClickTarget': itemClickTarget,
    'ItemClickFields': itemClickFields,
    'ColumnConfig': columnConfig,
    'SortOrder': sortOrder,
    'ChildCount': childCount,
  };
}
