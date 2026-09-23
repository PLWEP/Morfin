import 'package:flutter/material.dart';
import '../lobby_contract.dart';
import 'kpi_approvals_card.dart';
import 'kpi_plant_oee_card.dart';
import 'kpi_stock_alerts_card.dart';
import 'kpi_work_orders_card.dart';

class LobbyKpiGrid extends StatelessWidget {
  final List<KpiItem> kpis;

  const LobbyKpiGrid({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.18,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        KpiApprovalsCard(),
        KpiWorkOrdersCard(),
        KpiPlantOeeCard(),
        KpiStockAlertsCard(),
      ],
    );
  }
}
