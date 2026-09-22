import 'package:flutter/material.dart';

@immutable
class KpiItem {
  final String title;
  final String? badgeText;
  final String? badgeDotType; // 'warning', etc.
  final String mainValue;
  final String mainUnit;
  final String subValue;
  final String statusType; // 'warning', 'active', 'success', 'critical'
  final IconData bottomIcon;
  final String bottomText;
  final List<double>? sparklineData;

  const KpiItem({
    required this.title,
    this.badgeText,
    this.badgeDotType,
    required this.mainValue,
    required this.mainUnit,
    required this.subValue,
    required this.statusType,
    required this.bottomIcon,
    required this.bottomText,
    this.sparklineData,
  });
}

@immutable
class OperationalFeed {
  final String badgeTag;
  final String badgeType; // 'critical', 'warning', 'success'
  final String itemId;
  final String urgencyText;
  final String urgencyType;
  final IconData urgencyIcon;
  final String title;
  final String description;
  final String footerMeta;
  final IconData footerIcon;

  const OperationalFeed({
    required this.badgeTag,
    required this.badgeType,
    required this.itemId,
    required this.urgencyText,
    required this.urgencyType,
    required this.urgencyIcon,
    required this.title,
    required this.description,
    required this.footerMeta,
    required this.footerIcon,
  });
}

@immutable
class LobbyState {
  final int selectedNavIndex;
  final String connectionNode;
  final int unreadAlertCount;
  final List<KpiItem> kpis;
  final List<OperationalFeed> feeds;

  const LobbyState({
    required this.selectedNavIndex,
    required this.connectionNode,
    required this.unreadAlertCount,
    required this.kpis,
    required this.feeds,
  });

  factory LobbyState.initial() {
    return const LobbyState(
      selectedNavIndex: 0,
      connectionNode: 'US-EAST-01 • 24ms',
      unreadAlertCount: 2,
      kpis: [
        KpiItem(
          title: 'APPROVALS',
          badgeDotType: 'warning',
          mainValue: '7',
          mainUnit: 'Orders',
          subValue: '\$142.5K Pending',
          statusType: 'warning',
          bottomIcon: Icons.schedule_rounded,
          bottomText: 'Action required',
        ),
        KpiItem(
          title: 'WORK ORDERS',
          badgeText: '4 CRIT',
          mainValue: '24',
          mainUnit: 'Active',
          subValue: 'Field Teams Engaged',
          statusType: 'active',
          bottomIcon: Icons.crisis_alert_rounded,
          bottomText: '3 awaiting sign-off',
        ),
        KpiItem(
          title: 'PLANT OEE',
          badgeText: '+1.8%',
          mainValue: '94.2%',
          mainUnit: '',
          subValue: 'Target Exceeded',
          statusType: 'success',
          bottomIcon: Icons.bolt_rounded,
          bottomText: 'Optimal Telemetry',
          sparklineData: [24, 20, 22, 14, 16, 4],
        ),
        KpiItem(
          title: 'STOCK ALERTS',
          badgeText: 'Depleted',
          mainValue: '3',
          mainUnit: 'Low Stock',
          subValue: 'Spares Warehouse',
          statusType: 'critical',
          bottomIcon: Icons.warning_amber_rounded,
          bottomText: 'Auto-PO drafted',
        ),
      ],
      feeds: [
        OperationalFeed(
          badgeTag: 'CRITICAL WO',
          badgeType: 'critical',
          itemId: '#WO-8942',
          urgencyText: '18m remaining',
          urgencyType: 'warning',
          urgencyIcon: Icons.timer_outlined,
          title: 'Turbine Coolant Pressure Loss',
          description: 'Sector 4 Generator B • Pressure dropped below 1.2 bar safety threshold.',
          footerMeta: 'Tech: Marc Chen • Assigned 24m ago',
          footerIcon: Icons.engineering_outlined,
        ),
        OperationalFeed(
          badgeTag: 'PR APPROVAL',
          badgeType: 'warning',
          itemId: '#PO-10499',
          urgencyText: '\$18,450.00',
          urgencyType: 'active',
          urgencyIcon: Icons.payments_outlined,
          title: 'High-temp Ceramic Bearings',
          description: '12 Units • Vendor: SKF Precision Systems • Awaiting Director Clearance.',
          footerMeta: 'Requester: Sarah Jenkins (Maint Lead)',
          footerIcon: Icons.assignment_ind_outlined,
        ),
        OperationalFeed(
          badgeTag: 'TELEMETRY NOMINAL',
          badgeType: 'success',
          itemId: '#NODE-204',
          urgencyText: '68.4°C • Stable',
          urgencyType: 'success',
          urgencyIcon: Icons.thermostat_rounded,
          title: 'Continuous Rotary Compressor 03',
          description: 'Bearing vibration 0.42 mm/s • Airflow 420 CFM • Next inspection in 14 days.',
          footerMeta: 'SCADA Channel 8 • Live telemetry',
          footerIcon: Icons.sensors_rounded,
        ),
      ],
    );
  }

  LobbyState copyWith({
    int? selectedNavIndex,
    String? connectionNode,
    int? unreadAlertCount,
    List<KpiItem>? kpis,
    List<OperationalFeed>? feeds,
  }) {
    return LobbyState(
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      connectionNode: connectionNode ?? this.connectionNode,
      unreadAlertCount: unreadAlertCount ?? this.unreadAlertCount,
      kpis: kpis ?? this.kpis,
      feeds: feeds ?? this.feeds,
    );
  }
}

sealed class LobbyAction {
  const LobbyAction();
}

class LobbySelectNavAction extends LobbyAction {
  final int index;
  const LobbySelectNavAction(this.index);
}

class LobbyTriggerTacticalAction extends LobbyAction {
  final String actionId;
  const LobbyTriggerTacticalAction(this.actionId);
}
