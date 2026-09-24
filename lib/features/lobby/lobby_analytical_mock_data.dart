import 'package:flutter/material.dart';
import 'lobby_contract.dart';

abstract final class LobbyAnalyticalMockData {
  static LobbyState stateForPeriod(DashboardPeriod period) {
    return switch (period) {
      DashboardPeriod.today => _todayState,
      DashboardPeriod.thisWeek => _weekState,
      DashboardPeriod.thisMonth => _monthState,
    };
  }

  static const _todayState = LobbyState(
    period: DashboardPeriod.today,
    kpis: [
      AnalyticalKpi(
        title: 'Plant OEE', value: '94.2%', change: '+2.4%', isPositive: true,
        benchmark: 'Target: 90.0%', icon: Icons.speed_rounded, trendPoints: [88, 91, 89, 93, 92, 94.2],
      ),
      AnalyticalKpi(
        title: 'Production Yield', value: '14,820', unit: 'units', change: '+5.3%', isPositive: true,
        benchmark: 'Target: 14,000', icon: Icons.precision_manufacturing_rounded, trendPoints: [2100, 4300, 6900, 9800, 12400, 14820],
      ),
      AnalyticalKpi(
        title: 'Quality Rate', value: '98.8%', change: '+0.6%', isPositive: true,
        benchmark: 'Scrap: 0.7%', icon: Icons.verified_rounded, trendPoints: [98.1, 98.3, 98.2, 98.5, 98.7, 98.8],
      ),
      AnalyticalKpi(
        title: 'Downtime', value: '14', unit: 'min', change: '-18%', isPositive: true,
        benchmark: 'Avg: 22 min', icon: Icons.timer_outlined, trendPoints: [32, 28, 22, 19, 16, 14],
      ),
    ],
    throughputChart: [
      ChartDataPoint(label: '08:00', actual: 1850, target: 1750),
      ChartDataPoint(label: '10:00', actual: 2420, target: 2200),
      ChartDataPoint(label: '12:00', actual: 2680, target: 2400),
      ChartDataPoint(label: '14:00', actual: 2540, target: 2400),
      ChartDataPoint(label: '16:00', actual: 2790, target: 2500),
      ChartDataPoint(label: '18:00', actual: 2540, target: 2400),
    ],
    oeeFactors: [
      OeeFactor(name: 'Availability', percentage: 0.964, target: 0.92, details: '14m unplanned stop'),
      OeeFactor(name: 'Performance', percentage: 0.938, target: 0.90, details: '104% cycle speed'),
      OeeFactor(name: 'Quality', percentage: 0.988, target: 0.98, details: '99.1% first pass yield'),
    ],
    linePerformances: [
      LinePerformance(lineName: 'Line 1 (Assembly)', efficiency: 0.96, outputUnits: 4820, targetUnits: 5000, status: 'Optimal'),
      LinePerformance(lineName: 'Line 2 (Packaging)', efficiency: 0.94, outputUnits: 4100, targetUnits: 4200, status: 'Normal'),
      LinePerformance(lineName: 'Line 3 (Fabrication)', efficiency: 0.89, outputUnits: 3250, targetUnits: 3500, status: 'Attention'),
      LinePerformance(lineName: 'Line 4 (Logistics)', efficiency: 0.98, outputUnits: 2650, targetUnits: 2700, status: 'Optimal'),
    ],
    insights: [
      DashboardInsight(
        title: 'Line 1 reached peak throughput',
        description: 'Assembly cell achieved 108% of target volume with zero rework tickets.',
        icon: Icons.trending_up_rounded, isPositive: true,
      ),
      DashboardInsight(
        title: 'Material scrap rate minimized',
        description: 'Overall defect index dropped to 0.72%, beating weekly quality threshold.',
        icon: Icons.check_circle_outline_rounded, isPositive: true,
      ),
    ],
  );

  static const _weekState = LobbyState(
    period: DashboardPeriod.thisWeek,
    kpis: [
      AnalyticalKpi(
        title: 'Plant OEE', value: '93.6%', change: '+1.9%', isPositive: true,
        benchmark: 'Target: 90.0%', icon: Icons.speed_rounded, trendPoints: [91, 92, 92.5, 93, 93.4, 93.6],
      ),
      AnalyticalKpi(
        title: 'Production Yield', value: '98,450', unit: 'units', change: '+4.2%', isPositive: true,
        benchmark: 'Target: 95,000', icon: Icons.precision_manufacturing_rounded, trendPoints: [16000, 33000, 51000, 68000, 84000, 98450],
      ),
      AnalyticalKpi(
        title: 'Quality Rate', value: '98.4%', change: '+0.3%', isPositive: true,
        benchmark: 'Scrap: 0.8%', icon: Icons.verified_rounded, trendPoints: [98.0, 98.1, 98.2, 98.3, 98.4, 98.4],
      ),
      AnalyticalKpi(
        title: 'Downtime', value: '1.8', unit: 'hrs', change: '-24%', isPositive: true,
        benchmark: 'Avg: 2.4 hrs', icon: Icons.timer_outlined, trendPoints: [3.2, 2.8, 2.5, 2.1, 1.9, 1.8],
      ),
    ],
    throughputChart: [
      ChartDataPoint(label: 'Mon', actual: 16200, target: 15500),
      ChartDataPoint(label: 'Tue', actual: 16800, target: 15500),
      ChartDataPoint(label: 'Wed', actual: 17100, target: 16000),
      ChartDataPoint(label: 'Thu', actual: 16400, target: 16000),
      ChartDataPoint(label: 'Fri', actual: 17200, target: 16000),
      ChartDataPoint(label: 'Sat', actual: 14750, target: 14000),
    ],
    oeeFactors: [
      OeeFactor(name: 'Availability', percentage: 0.952, target: 0.92, details: '1.8h scheduled stops'),
      OeeFactor(name: 'Performance', percentage: 0.928, target: 0.90, details: '102% target pace'),
      OeeFactor(name: 'Quality', percentage: 0.984, target: 0.98, details: '98.9% yield rate'),
    ],
    linePerformances: [
      LinePerformance(lineName: 'Line 1 (Assembly)', efficiency: 0.95, outputUnits: 32400, targetUnits: 33000, status: 'Optimal'),
      LinePerformance(lineName: 'Line 2 (Packaging)', efficiency: 0.93, outputUnits: 27500, targetUnits: 28000, status: 'Normal'),
      LinePerformance(lineName: 'Line 3 (Fabrication)', efficiency: 0.91, outputUnits: 21800, targetUnits: 23000, status: 'Normal'),
      LinePerformance(lineName: 'Line 4 (Logistics)', efficiency: 0.97, outputUnits: 16750, targetUnits: 17000, status: 'Optimal'),
    ],
    insights: [
      DashboardInsight(
        title: 'Weekly output exceeded target by 3,450 units',
        description: 'Consistent shifts from Assembly and Packaging drove record weekly volume.',
        icon: Icons.insights_rounded, isPositive: true,
      ),
      DashboardInsight(
        title: 'Line 3 preventative service completed',
        description: 'Scheduled calibration mitigated planned downtime for the remainder of month.',
        icon: Icons.build_circle_outlined, isPositive: true,
      ),
    ],
  );

  static const _monthState = LobbyState(
    period: DashboardPeriod.thisMonth,
    kpis: [
      AnalyticalKpi(
        title: 'Plant OEE', value: '93.1%', change: '+1.5%', isPositive: true,
        benchmark: 'Target: 90.0%', icon: Icons.speed_rounded, trendPoints: [90.5, 91.2, 92.1, 92.8, 93.0, 93.1],
      ),
      AnalyticalKpi(
        title: 'Production Yield', value: '412,600', unit: 'units', change: '+6.1%', isPositive: true,
        benchmark: 'Target: 390,000', icon: Icons.precision_manufacturing_rounded, trendPoints: [70000, 145000, 220000, 290000, 360000, 412600],
      ),
      AnalyticalKpi(
        title: 'Quality Rate', value: '98.2%', change: '+0.2%', isPositive: true,
        benchmark: 'Scrap: 0.9%', icon: Icons.verified_rounded, trendPoints: [97.9, 98.0, 98.1, 98.2, 98.2, 98.2],
      ),
      AnalyticalKpi(
        title: 'Downtime', value: '7.4', unit: 'hrs', change: '-31%', isPositive: true,
        benchmark: 'Avg: 10.8 hrs', icon: Icons.timer_outlined, trendPoints: [12.2, 10.5, 9.4, 8.8, 8.0, 7.4],
      ),
    ],
    throughputChart: [
      ChartDataPoint(label: 'W1', actual: 98000, target: 95000),
      ChartDataPoint(label: 'W2', actual: 104000, target: 95000),
      ChartDataPoint(label: 'W3', actual: 102500, target: 98000),
      ChartDataPoint(label: 'W4', actual: 108100, target: 98000),
    ],
    oeeFactors: [
      OeeFactor(name: 'Availability', percentage: 0.948, target: 0.92, details: '7.4h maintenance'),
      OeeFactor(name: 'Performance', percentage: 0.921, target: 0.90, details: '101% standard velocity'),
      OeeFactor(name: 'Quality', percentage: 0.982, target: 0.98, details: '98.7% first time right'),
    ],
    linePerformances: [
      LinePerformance(lineName: 'Line 1 (Assembly)', efficiency: 0.94, outputUnits: 135000, targetUnits: 138000, status: 'Optimal'),
      LinePerformance(lineName: 'Line 2 (Packaging)', efficiency: 0.92, outputUnits: 114000, targetUnits: 118000, status: 'Normal'),
      LinePerformance(lineName: 'Line 3 (Fabrication)', efficiency: 0.90, outputUnits: 92000, targetUnits: 95000, status: 'Normal'),
      LinePerformance(lineName: 'Line 4 (Logistics)', efficiency: 0.96, outputUnits: 71600, targetUnits: 72000, status: 'Optimal'),
    ],
    insights: [
      DashboardInsight(
        title: 'Monthly operational throughput at all-time high',
        description: 'Total output exceeded quarterly projection by +5.8% across all lines.',
        icon: Icons.emoji_events_outlined, isPositive: true,
      ),
    ],
  );
}
