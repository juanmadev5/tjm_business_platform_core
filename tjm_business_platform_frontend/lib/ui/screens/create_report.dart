import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/state/report_controller.dart';
import 'package:tjm_business_platform/ui/components/app_button.dart';
import 'package:tjm_business_platform/ui/components/details_field.dart';
import 'package:tjm_business_platform/ui/components/name_field.dart';
import 'package:tjm_business_platform/ui/components/price_field.dart';
import 'package:tjm_business_platform/ui/components/responsive_layout.dart';
import 'package:tjm_business_platform/ui/utils/currency_format.dart';
import 'package:tjm_business_platform_logic/core/action_result.dart';
import 'package:tjm_business_platform_logic/core/model/platform_user.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';

class CreateReport extends StatefulWidget {
  final PlatformUser? user;
  const CreateReport({super.key, required this.user});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  String name = "";
  String details = "";
  String price = "";
  bool isCompleted = false;
  bool isPaid = false;

  String? selectedCustomerId;
  List<Map<String, String>> suggestions = [];
  bool isSearching = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _detailFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();

  final ReportController _controller = ReportController();
  final Data data = Data();
  bool error = false;
  bool saved = false;

  void _onNameChanged(String value) async {
    setState(() {
      name = value;
      isSearching = true;
      if (selectedCustomerId != null) {
        selectedCustomerId = null;
      }
    });

    if (value.isEmpty) {
      setState(() {
        suggestions = [];
        selectedCustomerId = null;
        isSearching = false;
      });
      return;
    }

    final result = await data.appDatabase.findCustomersByNameFragment(value);

    setState(() {
      suggestions = result;
      isSearching = false;
      selectedCustomerId = null;
    });
  }

  void _saveReport(PlatformUser user) async {
    if (name.isEmpty || details.isEmpty || price.isEmpty) {
      setState(() => error = true);
      return;
    }

    var formattedPrice = parseGsToDouble(price);

    final result = await _controller.createReport(
      customerName: name,
      details: details,
      price: double.parse(formattedPrice.toString()),
      isCompleted: isCompleted,
      isPaid: isPaid,
      author: "${user.name} ${user.lastName}",
      existingCustomerId: selectedCustomerId,
    );

    if (!mounted) return;

    if (result == ActionResult.ok) {
      setState(() {
        error = false;
        saved = true;
      });
    } else {
      setState(() => error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(AppStrings.createReport)),
      body: ResponsiveLayout(
        mobileBody: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _formContent(user, false),
        ),
        desktopBody: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(32),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: _formContent(user, true),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formContent(PlatformUser user, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (error)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              AppStrings.errorOnSaveReport,
              style: TextStyle(color: AppColors.seedColor.error),
            ),
          ),
        if (saved)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              AppStrings.reportSaveSuccess,
              style: TextStyle(color: AppColors.seedColor.primary),
            ),
          ),

        if (!isDesktop) ..._formFields(user),

        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _formFields(user)[0],
                    if (!isSearching && suggestions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _formFields(user)[1],
                    ],
                    const SizedBox(height: 16),
                    _formFields(user)[2],
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _formFields(user)[3],
                    const SizedBox(height: 16),
                    _formFields(user)[4],
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 200,
                        child: AppButton(
                          text: AppStrings.saveReport,
                          onPressed: () => _saveReport(user),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        const SizedBox(height: 32),
        if (!isDesktop)
          Center(
            child: SizedBox(
              width: 200,
              child: AppButton(
                text: AppStrings.saveReport,
                onPressed: () => _saveReport(user),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _formFields(PlatformUser user) {
    var isDesktop = MediaQuery.of(context).size.width > 800;
    return [
      nameField(
        AppStrings.customerName,
        (value) {
          setState(() {
            name = value;
          });
          _onNameChanged(value);
        },
        _nameFocus,
        () => FocusScope.of(context).requestFocus(_detailFocus),
        _nameController,
      ),

      Column(
        children: suggestions.map((customer) {
          return ListTile(
            title: Text(customer["name"]!),
            subtitle: Text(customer["phoneNumber"]!),
            onTap: () {
              setState(() {
                name = customer["name"]!;
                selectedCustomerId = customer["id"]!;
                _nameController.text = name;
                suggestions.clear();
              });
            },
          );
        }).toList(),
      ),
      if (!isDesktop) const SizedBox(height: 18),

      detailsField(
        AppStrings.workDetails,
        (detail) => setState(() => details = detail),
        _detailFocus,
        () => FocusScope.of(context).requestFocus(_priceFocus),
      ),
      if (!isDesktop) const SizedBox(height: 18),
      priceField(
        AppStrings.priceGs,
        (p) => setState(() => price = p),
        _priceFocus,
        () {},
      ),

      Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: isCompleted,
                onChanged: (bool? value) =>
                    setState(() => isCompleted = value ?? false),
              ),
              Text(AppStrings.completed),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: isPaid,
                onChanged: (bool? value) =>
                    setState(() => isPaid = value ?? false),
              ),
              Text(AppStrings.paid),
            ],
          ),
        ],
      ),
    ];
  }
}
