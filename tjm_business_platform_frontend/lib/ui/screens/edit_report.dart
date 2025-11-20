import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/state/report_controller.dart';
import 'package:tjm_business_platform/ui/components/app_button.dart';
import 'package:tjm_business_platform/ui/components/details_field.dart';
import 'package:tjm_business_platform/ui/components/name_field.dart';
import 'package:tjm_business_platform/ui/components/price_field.dart';
import 'package:tjm_business_platform/ui/utils/currency_format.dart';
import 'package:tjm_business_platform_logic/core/action_result.dart';
import 'package:tjm_business_platform_logic/core/model/platform_user.dart';
import 'package:tjm_business_platform_logic/core/model/report.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';
import 'package:uuid/uuid.dart';

class EditReport extends StatefulWidget {
  final Report reportToEdit;
  final PlatformUser user;
  const EditReport({super.key, required this.reportToEdit, required this.user});

  @override
  State<EditReport> createState() => _EditReportState();
}

class _EditReportState extends State<EditReport> {
  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  late TextEditingController _priceController;

  bool isCompleted = false;
  bool isPaid = false;

  String? selectedCustomerId;
  List<Map<String, String>> suggestions = [];
  bool isSearching = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _detailFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();

  final ReportController _controller = ReportController();
  final Data data = Data(); // Still needed for customer search
  bool error = false;
  bool saved = false;

  @override
  void initState() {
    super.initState();

    // Inicializamos los controllers con los datos existentes
    _nameController = TextEditingController(
      text: widget.reportToEdit.customerName,
    );
    _detailsController = TextEditingController(
      text: widget.reportToEdit.detail,
    );
    _priceController = TextEditingController(
      text: widget.reportToEdit.price.toStringAsFixed(0),
    );

    isCompleted = !widget.reportToEdit.isPending;
    isPaid = widget.reportToEdit.isPaid;
    selectedCustomerId = widget.reportToEdit.customerId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _priceController.dispose();
    _nameFocus.dispose();
    _detailFocus.dispose();
    _priceFocus.dispose();
    super.dispose();
  }

  void _onNameChanged(String value) async {
    setState(() {
      isSearching = true;
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

  void _deleteReport(Report report) async {
    final result = await _controller.deleteReport(report.id);

    if (!mounted) return;

    if (result == ActionResult.ok) {
      setState(() {
        error = false;
        saved = true;
      });
      Navigator.pop(context, true);
    } else {
      setState(() => error = true);
    }
  }

  void _saveReport(PlatformUser user) async {
    var formattedPrice = parseGsToDouble(_priceController.text);
    var rep = Report(
      id: widget.reportToEdit.id,
      author: "${user.name} ${user.lastName}",
      customerId: selectedCustomerId ?? Uuid().v4(),
      customerName: _nameController.text,
      detail: _detailsController.text,
      price: double.parse(formattedPrice.toString()),
      isPending: !isCompleted,
      isPaid: isPaid,
    );

    if (_nameController.text.isNotEmpty &&
        _detailsController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      final result = await _controller.editReport(rep);

      if (!mounted) return;

      if (result == ActionResult.ok) {
        setState(() {
          error = false;
          saved = true;
        });
        Navigator.pop(context, true);
      } else {
        setState(() => error = true);
      }
    } else {
      setState(() => error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user;

    bool isDesktop = MediaQuery.of(context).size.width > 800;
    var insets = const EdgeInsets.all(16.0);
    if (isDesktop) {
      insets = const EdgeInsets.only(left: 164, right: 164);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(AppStrings.editReport)),
      body: SingleChildScrollView(
        child: Padding(
          padding: insets,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: view(context, user),
          ),
        ),
      ),
    );
  }

  Column view(BuildContext context, PlatformUser user) {
    var colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (error)
          Text(
            AppStrings.errorOnSaveReport,
            style: TextStyle(color: colors.error),
          ),
        if (saved)
          Text(
            AppStrings.reportSaveSuccess,
            style: TextStyle(color: colors.primary),
          ),
        nameField(
          AppStrings.customerName,
          (value) => _onNameChanged(value),
          _nameFocus,
          () => FocusScope.of(context).requestFocus(_detailFocus),
          _nameController,
          context,
        ),
        if (!isSearching && suggestions.isNotEmpty)
          Column(
            children: suggestions.map((customer) {
              return ListTile(
                title: Text(customer["name"]!),
                subtitle: Text(customer["phoneNumber"]!),
                onTap: () {
                  setState(() {
                    _nameController.text = customer["name"]!;
                    selectedCustomerId = customer["id"]!;
                    suggestions.clear();
                  });
                },
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
        detailsField(
          AppStrings.workDetails,
          (detail) => setState(() {
            _detailsController.text = detail;
          }),
          _detailFocus,
          () => FocusScope.of(context).requestFocus(_priceFocus),
          controller: _detailsController,
          context: context,
        ),
        const SizedBox(height: 16),
        priceField(
          AppStrings.priceGs,
          (p) => setState(() {
            _priceController.text = p;
          }),
          _priceFocus,
          () {},
          controller: _priceController,
          context: context,
        ),
        Row(
          children: [
            Text(AppStrings.completed),
            Checkbox(
              value: isCompleted,
              onChanged: (bool? value) {
                setState(() {
                  isCompleted = value!;
                });
              },
            ),
          ],
        ),
        Row(
          children: [
            Text(AppStrings.paid),
            Checkbox(
              value: isPaid,
              onChanged: (bool? value) {
                setState(() {
                  isPaid = value!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                text: AppStrings.saveReport,
                onPressed: () => _saveReport(user),
              ),
              const SizedBox(width: 16),
              AppButton(
                text: AppStrings.deleteReport,
                onPressed: () => _deleteReport(widget.reportToEdit),
                backgroundColor: colors.onSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
