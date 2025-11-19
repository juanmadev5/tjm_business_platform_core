import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
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
    final data = widget.data;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.generalResume)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          if (data == null) {
            return Center(child: Text("loading"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                if (isDesktop)
                  Padding(
                    padding: const EdgeInsets.only(left: 128, right: 128),
                    child: Center(child: wrap(data, colorScheme, isDesktop)),
                  )
                else
                  wrap(data, colorScheme, isDesktop),
              ],
            ),
          );
        },
      ),
    );
  }

  Wrap wrap(DashboardDataModel data, ColorScheme colorScheme, bool isDesktop) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildCard(
          title: AppStrings.totalIncomes,
          value: formatDoubleToGs(data.totalIncome),
          icon: Icons.trending_up,
          color: colorScheme.primary,
          isDesktop: isDesktop,
        ),
        _buildCard(
          title: AppStrings.totalExpenses,
          value: formatDoubleToGs(data.totalExpenses),
          icon: Icons.trending_down,
          color: colorScheme.error,
          isDesktop: isDesktop,
        ),
        _buildCard(
          title: AppStrings.netProfit,
          value: formatDoubleToGs(data.netProfit),
          icon: Icons.account_balance_wallet,
          color: colorScheme.secondary,
          isDesktop: isDesktop,
        ),
        _buildCard(
          title: AppStrings.totalReports,
          value: data.totalReports.toString(),
          icon: Icons.receipt_long,
          color: colorScheme.tertiary,
          isDesktop: isDesktop,
        ),
        _buildCard(
          title: AppStrings.totalCustomers,
          value: data.totalCustomers.toString(),
          icon: Icons.people,
          color: colorScheme.primaryContainer,
          textColor: colorScheme.onPrimaryContainer,
          isDesktop: isDesktop,
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    Color? textColor,
    required bool isDesktop,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: isDesktop ? 260 : double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
