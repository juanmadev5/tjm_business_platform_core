import 'package:flutter/material.dart';
import 'package:tjm_business_platform/ui/model/dashboard_data_model.dart';
import 'package:tjm_business_platform/ui/utils/currency_format.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardDataModel? data;
  const DashboardScreen({super.key, required this.data});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Resumen general",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildCard(
                  context,
                  title: "Ingresos Totales",
                  value: formatDoubleToGs(data.totalIncome),
                  icon: Icons.trending_up,
                  color: colorScheme.primary,
                ),
                _buildCard(
                  context,
                  title: "Gastos Totales",
                  value: formatDoubleToGs(data.totalExpenses),
                  icon: Icons.trending_down,
                  color: colorScheme.error,
                ),
                _buildCard(
                  context,
                  title: "Beneficio Neto",
                  value: formatDoubleToGs(data.netProfit),
                  icon: Icons.account_balance_wallet,
                  color: colorScheme.secondary,
                ),
                _buildCard(
                  context,
                  title: "Reportes Totales",
                  value: data.totalReports.toString(),
                  icon: Icons.receipt_long,
                  color: colorScheme.tertiary,
                ),
                _buildCard(
                  context,
                  title: "Clientes",
                  value: data.totalCustomers.toString(),
                  icon: Icons.people,
                  color: colorScheme.primaryContainer,
                  textColor: colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    Color? textColor,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.of(context).size.width > 600 ? 260 : double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor ?? cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
