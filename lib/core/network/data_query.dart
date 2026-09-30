class DataQuery {
  final String? filter;
  final List<String> select;
  final String? orderby;
  final int? top;
  final int? skip;
  final List<String> expand;
  final Map<String, dynamic> customParams;

  const DataQuery({
    this.filter,
    this.select = const [],
    this.orderby,
    this.top,
    this.skip,
    this.expand = const [],
    this.customParams = const {},
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{...customParams};
    if (filter != null && filter!.isNotEmpty) params['\$filter'] = filter;
    if (select.isNotEmpty) params['\$select'] = select.join(',');
    if (orderby != null && orderby!.isNotEmpty) params['\$orderby'] = orderby;
    if (top != null) params['\$top'] = top;
    if (skip != null) params['\$skip'] = skip;
    if (expand.isNotEmpty) params['\$expand'] = expand.join(',');
    return params;
  }

  static String? combineFilters({
    String? defaultFilter,
    String? searchQuery,
    List<String>? searchFields,
  }) {
    final conditions = <String>[];
    if (defaultFilter != null && defaultFilter.trim().isNotEmpty) {
      conditions.add('($defaultFilter)');
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty && searchFields != null && searchFields.isNotEmpty) {
      final q = searchQuery.trim();
      final searchOr = searchFields.map((f) => "contains($f, '$q')").join(' or ');
      conditions.add('($searchOr)');
    }
    return conditions.isNotEmpty ? conditions.join(' and ') : null;
  }
}
