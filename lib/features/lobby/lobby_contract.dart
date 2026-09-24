import 'package:flutter/material.dart';

enum DashboardPeriod {
  today,
  thisWeek,
  thisMonth,
}

@immutable
class AnalyticalKpi {
  final String title;
  final String value;
  final String unit;
  final String change;
  final bool isPositive;
  final String benchmark;
  final IconData icon;
  final List<double> trendPoints;

  const AnalyticalKpi({
    required this.title,
    required this.value,
    this.unit = '',
    required this.change,
    required this.isPositive,
    required this.benchmark,
    required this.icon,
    this.trendPoints = const [],
  });
}

@immutable
class ChartDataPoint {
  final String label;
  final double actual;
  final double target;

  const ChartDataPoint({
    required this.label,
    required this.actual,
    required this.target,
  });
}

@immutable
class OeeFactor {
  final String name;
  final double percentage;
  final double target;
  final String details;

  const OeeFactor({
    required this.name,
    required this.percentage,
    required this.target,
    required this.details,
  });
}

@immutable
class LinePerformance {
  final String lineName;
  final double efficiency;
  final int outputUnits;
  final int targetUnits;
  final String status;

  const LinePerformance({
    required this.lineName,
    required this.efficiency,
    required this.outputUnits,
    required this.targetUnits,
    required this.status,
  });
}

@immutable
class DashboardInsight {
  final String title;
  final String description;
  final IconData icon;
  final bool isPositive;

  const DashboardInsight({
    required this.title,
    required this.description,
    required this.icon,
    this.isPositive = true,
  });
}

@immutable
class LobbyState {
  final DashboardPeriod period;
  final List<AnalyticalKpi> kpis;
  final List<ChartDataPoint> throughputChart;
  final List<OeeFactor> oeeFactors;
  final List<LinePerformance> linePerformances;
  final List<DashboardInsight> insights;

  const LobbyState({
    required this.period,
    required this.kpis,
    required this.throughputChart,
    required this.oeeFactors,
    required this.linePerformances,
    required this.insights,
  });

  LobbyState copyWith({
    DashboardPeriod? period,
    List<AnalyticalKpi>? kpis,
    List<ChartDataPoint>? throughputChart,
    List<OeeFactor>? oeeFactors,
    List<LinePerformance>? linePerformances,
    List<DashboardInsight>? insights,
  }) {
    return LobbyState(
      period: period ?? this.period,
      kpis: kpis ?? this.kpis,
      throughputChart: throughputChart ?? this.throughputChart,
      oeeFactors: oeeFactors ?? this.oeeFactors,
      linePerformances: linePerformances ?? this.linePerformances,
      insights: insights ?? this.insights,
    );
  }
}

sealed class LobbyAction {
  const LobbyAction();
}

class LobbyChangePeriodAction extends LobbyAction {
  final DashboardPeriod period;
  const LobbyChangePeriodAction(this.period);
}
