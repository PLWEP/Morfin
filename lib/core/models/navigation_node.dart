class NavigationNode {
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
  final String? paramConfig;
  final int sortOrder;
  final int childCount;

  const NavigationNode({
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
    this.paramConfig,
    required this.sortOrder,
    required this.childCount,
  });

  factory NavigationNode.fromJson(Map<String, dynamic> json) {
    return NavigationNode(
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
      paramConfig: (json['ParamConfig'] ?? json['param_config']) as String?,
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
    'ParamConfig': paramConfig,
    'SortOrder': sortOrder,
    'ChildCount': childCount,
  };

  Map<String, dynamic> get paramDefaults {
    if (paramConfig == null || paramConfig!.isEmpty) return const {};
    final map = <String, dynamic>{};
    for (final token in paramConfig!.split('^')) {
      final t = token.trim();
      if (t.isEmpty) continue;
      final eq = t.indexOf('=');
      if (eq <= 0) continue;
      final k = t.substring(0, eq).trim();
      final v = t.substring(eq + 1).trim();
      if (k.toUpperCase() != 'HIDE') map[k] = v;
    }
    return map;
  }

  Set<String> get hiddenParams {
    if (paramConfig == null || paramConfig!.isEmpty) return const {};
    final hidden = <String>{};
    for (final token in paramConfig!.split('^')) {
      final t = token.trim();
      if (t.toUpperCase().startsWith('HIDE=')) {
        final raw = t.substring(5).trim();
        hidden.addAll(raw.split(',').map((s) => s.trim().toUpperCase()));
      }
    }
    return hidden;
  }
}
