import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/state/dashboard_controller.dart';
import 'package:tjm_business_platform/ui/model/dashboard_data_model.dart';
import 'package:tjm_business_platform/ui/utils/currency_format.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController _controller = DashboardController();

  @override
  void initState() {
    super.initState();
    _controller.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.generalResume)),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final data = _controller.dashboardData;
          final colorScheme = Theme.of(context).colorScheme;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;

              if (_controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_controller.errorMessage != null) {
                return Center(child: Text(_controller.errorMessage!));
              }

              if (data == null) {
                return const Center(child: Text("No data available"));
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
                        child: Column(
                          children: [
                            Center(child: wrap(data, colorScheme, isDesktop)),
                            const SizedBox(height: 32),
                            _buildRecentActivity(data, colorScheme, isDesktop),
                          ],
                        ),
                      )
                    else ...[
                      wrap(data, colorScheme, isDesktop),
                      const SizedBox(height: 32),
                      _buildRecentActivity(data, colorScheme, isDesktop),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRecentActivity(
    DashboardDataModel data,
    ColorScheme colorScheme,
    bool isDesktop,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.recentActivity,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        if (data.recentReports.isEmpty)
          const Center(child: Text(AppStrings.noRecentReports))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.recentReports.length,
            itemBuilder: (context, index) {
              final report = data.recentReports[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: report.isPaid
                        ? Colors.green
                        : Colors.orange,
                    child: Icon(
                      report.isPaid ? Icons.check : Icons.pending,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(report.customerName),
                  subtitle: Text(
                    report.workDetails,
                    style: TextStyle(overflow: .ellipsis),
                  ),
                  trailing: Text(formatDoubleToGs(report.price)),
                ),
              );
            },
          ),
      ],
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
        _buildCard(
          title: AppStrings.pending,
          value: data.pendingReportsCount.toString(),
          icon: Icons.pending_actions,
          color: Colors.orange,
          isDesktop: isDesktop,
        ),
        _buildCard(
          title: AppStrings.notPaidCount,
          value: data.unpaidReportsCount.toString(),
          icon: Icons.money_off,
          color: Colors.redAccent,
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
      width: isDesktop ? 300 : double.infinity,
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
