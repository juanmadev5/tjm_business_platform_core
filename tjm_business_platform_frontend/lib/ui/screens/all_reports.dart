import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/state/report_controller.dart';
import 'package:tjm_business_platform/ui/components/report_card.dart';
import 'package:tjm_business_platform/ui/components/responsive_layout.dart';
import 'package:tjm_business_platform/ui/screens/edit_report.dart';
import 'package:tjm_business_platform_logic/core/model/platform_user.dart';
import 'package:tjm_business_platform_logic/core/model/report.dart';

class AllReports extends StatefulWidget {
  final PlatformUser user;
  const AllReports({super.key, required this.user});

  @override
  State<AllReports> createState() => _AllReportsState();
}

class _AllReportsState extends State<AllReports> {
  final ReportController _controller = ReportController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (!_controller.hasData) {
      _controller.fetchReports();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_controller.isLoading &&
          _controller.hasMore) {
        _controller.fetchReports();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openEditReport(Report report) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditReport(reportToEdit: report, user: widget.user),
      ),
    );
    // Controller handles updates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.reports)),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.reports.isEmpty && _controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.reports.isEmpty) {
      return const Center(
        child: Text(AppStrings.noReports, style: TextStyle(fontSize: 18)),
      );
    }

    return ResponsiveLayout(
      mobileBody: _buildMobileList(),
      desktopBody: _buildDesktopGrid(),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _controller.reports.length + (_controller.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _controller.reports.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final report = _controller.reports[index];
        return ReportCard(report: report, onTap: () => _openEditReport(report));
      },
    );
  }

  Widget _buildDesktopGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 128, vertical: 16),
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3,
        ),
        itemCount: _controller.reports.length + (_controller.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _controller.reports.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final report = _controller.reports[index];
          return ReportCard(
            report: report,
            onTap: () => _openEditReport(report),
          );
        },
      ),
    );
  }
}
