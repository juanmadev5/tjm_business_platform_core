import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/ui/screens/edit_report.dart';
import 'package:tjm_business_platform/ui/utils/currency_format.dart';
import 'package:tjm_business_platform_logic/core/model/platform_user.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';
import 'package:tjm_business_platform_logic/core/model/report.dart';

class AllReports extends StatefulWidget {
  final PlatformUser user;
  const AllReports({super.key, required this.user});

  @override
  State<AllReports> createState() => _AllReportsState();
}

class _AllReportsState extends State<AllReports> {
  final Data data = Data();
  final ScrollController _scrollController = ScrollController();

  List<Report> reports = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        page++;
        _fetchReports();
      }
    });
  }

  Future<void> _fetchReports({bool reset = false}) async {
    if (reset) {
      reports.clear();
      page = 1;
      hasMore = true;
    }

    setState(() {
      isLoading = true;
    });

    final newReports = await data.appDatabase.getReportByPage(page);

    setState(() {
      if (newReports.length < 15) {
        hasMore = false;
      }
      reports.addAll(newReports);
      isLoading = false;
    });
  }

  Future<void> _openEditReport(Report report) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditReport(reportToEdit: report, user: widget.user),
      ),
    );

    if (result == true) {
      await _fetchReports(reset: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.reports)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          if (reports.isEmpty && isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (isDesktop) {
            // Grid para escritorio
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3,
                ),
                itemCount: reports.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= reports.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final report = reports[index];
                  return _reportCard(report);
                },
              ),
            );
          } else {
            // Lista para móvil
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: reports.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= reports.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final report = reports[index];
                return _reportCard(report);
              },
            );
          }
        },
      ),
    );
  }

  Widget _reportCard(Report report) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: IconButton(
          onPressed: () async {
            await _openEditReport(report);
          },
          icon: Icon(Icons.edit, color: AppColors.seedColor.primary),
        ),
        title: Text(
          report.customerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          report.detail,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(formatDoubleToGs(report.price)),
      ),
    );
  }
}
