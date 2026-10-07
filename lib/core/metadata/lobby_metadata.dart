import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'action_metadata.dart';

enum LobbyElementType { counter, indicator, barChart, lineChart, unknown }

@immutable
class LobbyGridSpan {
  final int col, row;
  const LobbyGridSpan({this.col = 1, this.row = 1});

  factory LobbyGridSpan.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LobbyGridSpan();
    return LobbyGridSpan(
      col: (json['col'] as num?)?.toInt() ?? 1,
      row: (json['row'] as num?)?.toInt() ?? 1,
    );
  }
}

@immutable
class LobbyElementMetadata {
  final String id, title;
  final LobbyElementType type;
  final String? subtitle, icon, value, unit, change, benchmark, colorToken;
  final bool isPositive;
  final LobbyGridSpan span;
  final List<double> trendPoints;
  final double? percentage, target;
  final List<Map<String, dynamic>> chartPoints, items;
  final ActionMetadata? action;
  final String? targetProjection, targetEndpoint, filterConditions;
  final int? navNodeId;

  const LobbyElementMetadata({
    required this.id, required this.type, required this.title,
    this.subtitle, this.icon, this.span = const LobbyGridSpan(),
    this.value, this.unit, this.change, this.isPositive = true,
    this.benchmark, this.trendPoints = const [], this.percentage,
    this.target, this.chartPoints = const [], this.items = const [],
    this.colorToken, this.action, this.targetProjection,
    this.targetEndpoint, this.filterConditions, this.navNodeId,
  });

  LobbyElementMetadata copyWith({
    String? value, String? change, bool? isPositive, String? benchmark,
    double? percentage, double? target, List<Map<String, dynamic>>? chartPoints,
  }) => LobbyElementMetadata(
    id: id, type: type, title: title, subtitle: subtitle, icon: icon, span: span,
    value: value ?? this.value, unit: unit, change: change ?? this.change,
    isPositive: isPositive ?? this.isPositive, benchmark: benchmark ?? this.benchmark,
    trendPoints: trendPoints, percentage: percentage ?? this.percentage,
    target: target ?? this.target, chartPoints: chartPoints ?? this.chartPoints,
    items: items, colorToken: colorToken, action: action, targetProjection: targetProjection,
    targetEndpoint: targetEndpoint, filterConditions: filterConditions, navNodeId: navNodeId,
  );

  factory LobbyElementMetadata.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] ?? json['ElementType'] ?? json['elementType'] ?? 'counter').toString().toLowerCase();
    final elemType = switch (typeStr) {
      'counter' => LobbyElementType.counter,
      'indicator' || 'gauge' => LobbyElementType.indicator,
      'barchart' || 'bar_chart' => LobbyElementType.barChart,
      'linechart' || 'line_chart' => LobbyElementType.lineChart,
      _ => LobbyElementType.unknown,
    };

    final rawTrend = (json['trendPoints'] ?? json['TrendPoints']) as List<dynamic>? ?? [];
    final trendPoints = rawTrend.map((e) => (e as num).toDouble()).toList();
    final targetProj = (json['targetProjection'] ?? json['TargetProjection']) as String?;
    final targetEndp = (json['targetEndpoint'] ?? json['TargetEndpoint']) as String?;
    final filterCond = (json['filterConditions'] ?? json['FilterConditions']) as String?;
    final navNodeId = (json['navNodeId'] as num?)?.toInt() ?? (json['NavNodeId'] as num?)?.toInt();

    final colSpan = (json['spanCol'] as num?)?.toInt() ?? (json['SpanCol'] as num?)?.toInt();
    final rowSpan = (json['spanRow'] as num?)?.toInt() ?? (json['SpanRow'] as num?)?.toInt();
    final spanObj = (colSpan != null || rowSpan != null)
        ? LobbyGridSpan(col: colSpan ?? 1, row: rowSpan ?? 1)
        : LobbyGridSpan.fromJson(json['span'] as Map<String, dynamic>?);

    ActionMetadata? act;
    if (json['action'] != null) {
      act = ActionMetadata.fromJson(json['action'] as Map<String, dynamic>);
    } else if (targetProj != null && targetEndp != null) {
      act = ActionMetadata(
        type: ActionType.navigate,
        target: '/record_list',
        params: {
          'projection': targetProj,
          'endpoint': targetEndp,
          'filter': filterCond,
          'title': json['title'] ?? json['Title'] ?? '',
          'nodeId': navNodeId ?? 0,
        },
      );
    }

    List<Map<String, dynamic>> chartPts = (json['chartPoints'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    double? pct = ((json['percentage'] ?? json['Percentage']) as num?)?.toDouble();
    double? tgt = ((json['target'] ?? json['Target']) as num?)?.toDouble();

    if (filterCond != null && filterCond.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(filterCond);
        if (decoded is List) {
          chartPts = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        } else if (decoded is Map) {
          pct ??= (decoded['percentage'] as num?)?.toDouble();
          tgt ??= (decoded['target'] as num?)?.toDouble();
          if (decoded['chartPoints'] is List) {
            chartPts = (decoded['chartPoints'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
          }
        }
      } catch (_) {}
    }

    return LobbyElementMetadata(
      id: (json['id'] ?? json['ElementId'] ?? '').toString(),
      type: elemType,
      title: (json['title'] ?? json['Title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? json['Subtitle']) as String?,
      icon: (json['icon'] ?? json['Icon']) as String?,
      span: spanObj,
      value: (json['value'] ?? json['Value'])?.toString(),
      unit: (json['unit'] ?? json['Unit']) as String?,
      change: (json['change'] ?? json['Change']) as String?,
      isPositive: (json['isPositive'] ?? json['IsPositive']) as bool? ?? true,
      benchmark: (json['benchmark'] ?? json['Benchmark']) as String?,
      trendPoints: trendPoints,
      percentage: pct,
      target: tgt,
      chartPoints: chartPts,
      items: (json['items'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>(),
      colorToken: (json['colorToken'] ?? json['ColorToken']) as String?,
      action: act,
      targetProjection: targetProj,
      targetEndpoint: targetEndp,
      filterConditions: filterCond,
      navNodeId: navNodeId,
    );
  }
}

@immutable
class LobbyPageMetadata {
  final String pageId, title;
  final String? subtitle;
  final List<LobbyElementMetadata> elements;

  const LobbyPageMetadata({
    required this.pageId, required this.title, this.subtitle, this.elements = const [],
  });

  const LobbyPageMetadata.empty()
      : pageId = '', title = '', subtitle = null, elements = const [];

  factory LobbyPageMetadata.fromJson(Map<String, dynamic> json) {
    final rawElems = (json['elements'] ?? json['Elements'] ?? json['value'] ?? []) as List<dynamic>? ?? [];
    return LobbyPageMetadata(
      pageId: (json['pageId'] ?? json['PageId'] ?? 'lobby_main').toString(),
      title: (json['title'] ?? json['Title'] ?? 'Lobby').toString(),
      subtitle: (json['subtitle'] ?? json['Subtitle']) as String?,
      elements: rawElems.whereType<Map>().map((e) => LobbyElementMetadata.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }
}
