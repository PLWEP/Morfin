import 'package:flutter/material.dart';
import 'menu_contract.dart';

abstract final class MenuQuickDispatchData {
  static const items = [
    QuickDispatchItem(
      id: 'qd-1',
      code: 'MOD-401',
      title: 'Work Orders',
      icon: Icons.engineering_rounded,
      badgeType: ModuleBadgeType.active,
    ),
    QuickDispatchItem(
      id: 'qd-2',
      code: 'INV-012',
      title: 'Warehouse',
      icon: Icons.warehouse_rounded,
      badgeText: '98%',
      badgeType: ModuleBadgeType.warning,
    ),
    QuickDispatchItem(
      id: 'qd-3',
      code: 'FIN-882',
      title: 'Approvals',
      icon: Icons.rule_folder_rounded,
      badgeText: '7',
      badgeType: ModuleBadgeType.critical,
    ),
    QuickDispatchItem(
      id: 'qd-4',
      code: 'MFG-200',
      title: 'Shop Floor',
      icon: Icons.precision_manufacturing_rounded,
      badgeType: ModuleBadgeType.success,
    ),
    QuickDispatchItem(
      id: 'qd-5',
      code: 'AST-104',
      title: 'Assets',
      icon: Icons.token_rounded,
    ),
  ];
}
