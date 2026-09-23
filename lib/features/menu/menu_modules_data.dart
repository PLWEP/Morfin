import 'package:flutter/material.dart';
import 'menu_contract.dart';

abstract final class MenuModulesData {
  static const items = [
    // 1. Operations & Manufacturing
    ModuleItem(
      id: 'mod-1',
      code: 'MOD-401',
      title: 'Work Orders',
      subtitle: 'Field diagnostics, PM tickets, overhaul logs',
      icon: Icons.assignment_rounded,
      category: 'ops',
      badgeText: '24 ACTIVE',
      badgeType: ModuleBadgeType.active,
    ),
    ModuleItem(
      id: 'mod-2',
      code: 'MFG-200',
      title: 'Shop Floor Execution',
      subtitle: 'Real-time routing, station tally, routing cards',
      icon: Icons.precision_manufacturing_rounded,
      category: 'ops',
      badgeText: 'LIVE',
      badgeType: ModuleBadgeType.success,
    ),
    ModuleItem(
      id: 'mod-3',
      code: 'QA-102',
      title: 'Quality Inspection (QA/QC)',
      subtitle: 'Tolerance validation, non-conformance reports',
      icon: Icons.verified_rounded,
      category: 'ops',
    ),
    ModuleItem(
      id: 'mod-4',
      code: 'IOT-801',
      title: 'Machine Telemetry (IoT)',
      subtitle: 'Vibration, thermal gradients, motor load feeds',
      icon: Icons.sensors_rounded,
      category: 'ops',
    ),

    // 2. Supply Chain & Inventory
    ModuleItem(
      id: 'mod-5',
      code: 'INV-012',
      title: 'Warehouse Stock & Bins',
      subtitle: 'Aisle lookup, pallet allocation, batch balances',
      icon: Icons.inventory_2_rounded,
      category: 'supply',
    ),
    ModuleItem(
      id: 'mod-6',
      code: 'REQ-304',
      title: 'Part Requisitions',
      subtitle: 'Internal transfers, cross-depot requests',
      icon: Icons.swap_horiz_rounded,
      category: 'supply',
      badgeText: '3 PENDING',
      badgeType: ModuleBadgeType.warning,
    ),
    ModuleItem(
      id: 'mod-7',
      code: 'LOG-550',
      title: 'Material Movements',
      subtitle: 'Dock intake, put-away queues, shipping manifests',
      icon: Icons.local_shipping_rounded,
      category: 'supply',
    ),
    ModuleItem(
      id: 'mod-8',
      code: 'SCN-001',
      title: 'High-Speed Scanner Utility',
      subtitle: 'Rugged optical reader, RFID tag interrogation',
      icon: Icons.qr_code_scanner_rounded,
      category: 'supply',
      badgeText: 'HARDWARE',
      badgeType: ModuleBadgeType.hardware,
    ),

    // 3. Procurement & Finance
    ModuleItem(
      id: 'mod-9',
      code: 'FIN-882',
      title: 'Purchase Approvals',
      subtitle: r'PO authorizations > $10,000 threshold',
      icon: Icons.rule_folder_rounded,
      category: 'fin',
      badgeText: '7 ACTION REQ',
      badgeType: ModuleBadgeType.critical,
    ),
    ModuleItem(
      id: 'mod-10',
      code: 'EXP-109',
      title: 'Expense Claims & Per Diem',
      subtitle: 'Travel disbursements, on-site tool allowances',
      icon: Icons.receipt_long_rounded,
      category: 'fin',
    ),
    ModuleItem(
      id: 'mod-11',
      code: 'CON-770',
      title: 'Vendor SLA Contracts',
      subtitle: 'Supplier agreements, master pricing catalogs',
      icon: Icons.description_rounded,
      category: 'fin',
    ),

    // 4. Maintenance & Field Service
    ModuleItem(
      id: 'mod-12',
      code: 'AST-104',
      title: 'Asset Hierarchy & Registry',
      subtitle: 'Equipment lineage, spare breakdown, warranties',
      icon: Icons.account_tree_rounded,
      category: 'maint',
    ),
    ModuleItem(
      id: 'mod-13',
      code: 'PM-901',
      title: 'Preventive Schedules (PM)',
      subtitle: 'Runtime cycles, seasonal overhaul roadmaps',
      icon: Icons.published_with_changes_rounded,
      category: 'maint',
    ),
    ModuleItem(
      id: 'mod-14',
      code: 'HLT-440',
      title: 'Equipment Health Index',
      subtitle: 'MTBF metrics, historical downtime analysis',
      icon: Icons.health_and_safety_rounded,
      category: 'maint',
    ),
    ModuleItem(
      id: 'mod-15',
      code: 'DSP-220',
      title: 'Mobile Field Dispatch Logs',
      subtitle: 'GPS technician tracking, route optimization',
      icon: Icons.share_location_rounded,
      category: 'maint',
    ),

    // 5. Workforce & Shifts
    ModuleItem(
      id: 'mod-16',
      code: 'CRW-110',
      title: 'Crew & Skill Assignment',
      subtitle: 'Certifications, gantry operators, roster sync',
      icon: Icons.group_rounded,
      category: 'workforce',
    ),
    ModuleItem(
      id: 'mod-17',
      code: 'SFT-204',
      title: 'Shift Handoff Logbook',
      subtitle: 'Night shift release, safety lockouts (LOTO)',
      icon: Icons.sync_alt_rounded,
      category: 'workforce',
    ),
    ModuleItem(
      id: 'mod-18',
      code: 'EHS-911',
      title: 'EHS Incident Reporting',
      subtitle: 'Near-miss telemetry, hazard identification',
      icon: Icons.warning_amber_rounded,
      category: 'workforce',
    ),
  ];
}
