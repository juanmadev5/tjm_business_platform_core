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
      body: body(),
    );
  }

  dynamic body() {
    if (reports.isEmpty && isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: reports.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= reports.length) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final report = reports[index];
          return ListTile(
            leading: IconButton(
              onPressed: () async {
                await _openEditReport(report);
              },
              icon: Icon(Icons.edit, color: AppColors.seedColor.primary),
            ),
            title: Text(report.customerName),
            subtitle: Text(
              report.detail,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(formatDoubleToGs(report.price)),
          );
        },
      );
    }
  }
}
