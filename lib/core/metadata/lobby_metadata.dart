import 'package:flutter/foundation.dart';
import 'action_metadata.dart';

enum LobbyElementType {
  counter,
  indicator,
  barChart,
  lineChart,
  list,
  linkTile,
  unknown,
}

@immutable
class LobbyGridSpan {
  final int col;
  final int row;

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
  final String id;
  final LobbyElementType type;
  final String title;
  final String? subtitle;
  final String? icon;
  final LobbyGridSpan span;
  final String? value;
  final String? unit;
  final String? change;
  final bool isPositive;
  final String? benchmark;
  final List<double> trendPoints;
  final double? percentage;
  final double? target;
  final List<Map<String, dynamic>> chartPoints;
  final List<Map<String, dynamic>> items;
  final String? colorToken;
  final ActionMetadata? action;

  const LobbyElementMetadata({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.icon,
    this.span = const LobbyGridSpan(),
    this.value,
    this.unit,
    this.change,
    this.isPositive = true,
    this.benchmark,
    this.trendPoints = const [],
    this.percentage,
    this.target,
    this.chartPoints = const [],
    this.items = const [],
    this.colorToken,
    this.action,
  });

  factory LobbyElementMetadata.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'counter';
    final elemType = switch (typeStr) {
      'counter' => LobbyElementType.counter,
      'indicator' || 'gauge' => LobbyElementType.indicator,
      'bar_chart' || 'barchart' => LobbyElementType.barChart,
      'line_chart' || 'linechart' => LobbyElementType.lineChart,
      'list' => LobbyElementType.list,
      'link' || 'link_tile' => LobbyElementType.linkTile,
      _ => LobbyElementType.unknown,
    };

    final rawTrend = json['trendPoints'] as List<dynamic>? ?? [];
    final trendPoints = rawTrend.map((e) => (e as num).toDouble()).toList();

    return LobbyElementMetadata(
      id: json['id'] as String? ?? '',
      type: elemType,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      icon: json['icon'] as String?,
      span: LobbyGridSpan.fromJson(json['span'] as Map<String, dynamic>?),
      value: json['value']?.toString(),
      unit: json['unit'] as String?,
      change: json['change'] as String?,
      isPositive: json['isPositive'] as bool? ?? true,
      benchmark: json['benchmark'] as String?,
      trendPoints: trendPoints,
      percentage: (json['percentage'] as num?)?.toDouble(),
      target: (json['target'] as num?)?.toDouble(),
      chartPoints: (json['chartPoints'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>(),
      items: (json['items'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>(),
      colorToken: json['colorToken'] as String?,
      action: json['action'] != null
          ? ActionMetadata.fromJson(json['action'] as Map<String, dynamic>)
          : null,
    );
  }
}

@immutable
class LobbyPageMetadata {
  final String pageId;
  final String title;
  final String? subtitle;
  final List<LobbyElementMetadata> elements;

  const LobbyPageMetadata({
    required this.pageId,
    required this.title,
    this.subtitle,
    this.elements = const [],
  });

  factory LobbyPageMetadata.fromJson(Map<String, dynamic> json) {
    final rawElems = json['elements'] as List<dynamic>? ?? [];
    return LobbyPageMetadata(
      pageId: json['pageId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      elements: rawElems
          .map((e) => LobbyElementMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
