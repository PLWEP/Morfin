class ODataQuery {
  final String? filter;
  final List<String> select;
  final String? orderby;
  final int? top;
  final int? skip;
  final List<String> expand;
  final Map<String, dynamic> customParams;

  const ODataQuery({
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
}
