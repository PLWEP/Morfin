import 'package:flutter/material.dart';
import 'menu_contract.dart';

abstract final class MenuModulesData {
  static const items = [
    // 1. Operations & Manufacturing
    ModuleItem(
      id: 'mod-1',
      code: 'OPS-101',
      title: 'Work Orders',
      subtitle: 'Maintenance tasks, diagnostics, and repairs',
      icon: Icons.assignment_rounded,
      category: 'ops',
      badgeText: '24 Active',
      badgeType: ModuleBadgeType.active,
    ),
    ModuleItem(
      id: 'mod-2',
      code: 'OPS-102',
      title: 'Shop Floor Execution',
      subtitle: 'Production progress and station tracking',
      icon: Icons.precision_manufacturing_rounded,
      category: 'ops',
      badgeText: 'Live',
      badgeType: ModuleBadgeType.success,
    ),
    ModuleItem(
      id: 'mod-3',
      code: 'OPS-103',
      title: 'Quality Inspection',
      subtitle: 'Quality checks and defect logs',
      icon: Icons.verified_rounded,
      category: 'ops',
    ),
    ModuleItem(
      id: 'mod-4',
      code: 'OPS-104',
      title: 'Machine Telemetry',
      subtitle: 'Sensor readings, temperature, and motor status',
      icon: Icons.sensors_rounded,
      category: 'ops',
    ),

    // 2. Supply Chain & Inventory
    ModuleItem(
      id: 'mod-5',
      code: 'INV-201',
      title: 'Warehouse Stock',
      subtitle: 'Inventory levels, bin locations, and batches',
      icon: Icons.inventory_2_rounded,
      category: 'supply',
    ),
    ModuleItem(
      id: 'mod-6',
      code: 'INV-202',
      title: 'Part Requisitions',
      subtitle: 'Material requests and internal transfers',
      icon: Icons.swap_horiz_rounded,
      category: 'supply',
      badgeText: '3 Pending',
      badgeType: ModuleBadgeType.warning,
    ),
    ModuleItem(
      id: 'mod-7',
      code: 'INV-203',
      title: 'Material Movements',
      subtitle: 'Receiving, shipping, and put-away tasks',
      icon: Icons.local_shipping_rounded,
      category: 'supply',
    ),
    ModuleItem(
      id: 'mod-8',
      code: 'INV-204',
      title: 'Barcode Scanner',
      subtitle: 'Scan QR codes and asset tags',
      icon: Icons.qr_code_scanner_rounded,
      category: 'supply',
    ),

    // 3. Procurement & Finance
    ModuleItem(
      id: 'mod-9',
      code: 'FIN-301',
      title: 'Purchase Approvals',
      subtitle: 'Purchase orders awaiting manager sign-off',
      icon: Icons.rule_folder_rounded,
      category: 'fin',
      badgeText: '7 Pending',
      badgeType: ModuleBadgeType.critical,
    ),
    ModuleItem(
      id: 'mod-10',
      code: 'FIN-302',
      title: 'Expense Claims',
      subtitle: 'Travel and tool reimbursement requests',
      icon: Icons.receipt_long_rounded,
      category: 'fin',
    ),
    ModuleItem(
      id: 'mod-11',
      code: 'FIN-303',
      title: 'Vendor Contracts',
      subtitle: 'Supplier agreements and pricing terms',
      icon: Icons.description_rounded,
      category: 'fin',
    ),

    // 4. Maintenance & Field Service
    ModuleItem(
      id: 'mod-12',
      code: 'MNT-401',
      title: 'Asset Registry',
      subtitle: 'Equipment details, serial numbers, and warranty',
      icon: Icons.account_tree_rounded,
      category: 'maint',
    ),
    ModuleItem(
      id: 'mod-13',
      code: 'MNT-402',
      title: 'Preventive Maintenance',
      subtitle: 'Scheduled service and routine checkups',
      icon: Icons.published_with_changes_rounded,
      category: 'maint',
    ),
    ModuleItem(
      id: 'mod-14',
      code: 'MNT-403',
      title: 'Equipment Health',
      subtitle: 'Downtime records and reliability metrics',
      icon: Icons.health_and_safety_rounded,
      category: 'maint',
    ),
    ModuleItem(
      id: 'mod-15',
      code: 'MNT-404',
      title: 'Field Service Dispatch',
      subtitle: 'Technician assignments and route logs',
      icon: Icons.share_location_rounded,
      category: 'maint',
    ),

    // 5. Workforce & Shifts
    ModuleItem(
      id: 'mod-16',
      code: 'WKF-501',
      title: 'Crew Assignment',
      subtitle: 'Staff scheduling and team certifications',
      icon: Icons.group_rounded,
      category: 'workforce',
    ),
    ModuleItem(
      id: 'mod-17',
      code: 'WKF-502',
      title: 'Shift Logbook',
      subtitle: 'Handoff notes and daily shift summaries',
      icon: Icons.sync_alt_rounded,
      category: 'workforce',
    ),
    ModuleItem(
      id: 'mod-18',
      code: 'WKF-503',
      title: 'Safety & Incidents',
      subtitle: 'Safety reporting and incident logs',
      icon: Icons.warning_amber_rounded,
      category: 'workforce',
    ),
  ];
}
