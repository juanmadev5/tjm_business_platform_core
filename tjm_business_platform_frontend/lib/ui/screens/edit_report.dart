import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
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

  Data data = Data();
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
      final result = await data.appDatabase.editReport(rep);

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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(AppStrings.createReport)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (error)
                Text(
                  AppStrings.errorOnSaveReport,
                  style: TextStyle(color: AppColors.seedColor.error),
                ),
              if (saved)
                Text(
                  AppStrings.reportSaveSuccess,
                  style: TextStyle(color: AppColors.seedColor.primary),
                ),
              nameField(
                AppStrings.customerName,
                (value) => _onNameChanged(value),
                _nameFocus,
                () => FocusScope.of(context).requestFocus(_detailFocus),
                _nameController,
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
              SizedBox(height: 16),
              detailsField(
                AppStrings.workDetails,
                (detail) => setState(() {
                  _detailsController.text = detail;
                }),
                _detailFocus,
                () => FocusScope.of(context).requestFocus(_priceFocus),
                controller: _detailsController,
              ),
              SizedBox(height: 16),
              priceField(
                AppStrings.priceGs,
                (p) => setState(() {
                  _priceController.text = p;
                }),
                _priceFocus,
                () {},
                controller: _priceController,
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
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveReport(user);
                  },
                  child: Text(AppStrings.saveReport),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
