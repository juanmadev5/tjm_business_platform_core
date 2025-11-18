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

  final Data data = Data();
  bool error = false;
  bool saved = false;

  void _onNameChanged(String value) async {
    setState(() {
      name = value;
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
    var formattedPrice = parseGsToDouble(price);
    var rep = Report(
      id: Uuid().v4(),
      author: "${user.name} ${user.lastName}",
      customerId: selectedCustomerId ?? Uuid().v4(),
      customerName: name,
      detail: details,
      price: double.parse(formattedPrice.toString()),
      isPending: isCompleted,
      isPaid: isPaid,
    );

    if (name.isNotEmpty && details.isNotEmpty && price.isNotEmpty) {
      final result = await data.appDatabase.addNewReport(rep);

      if (!mounted) return;

      if (result == ActionResult.ok) {
        setState(() {
          error = false;
          saved = true;
        });
      } else {
        setState(() => error = true);
      }
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          final content = _formContent(user);

          if (isDesktop) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(32),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: content,
                  ),
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: content,
            );
          }
        },
      ),
    );
  }

  Widget _formContent(PlatformUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (error)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              AppStrings.errorOnSaveReport,
              style: TextStyle(color: AppColors.seedColor.error),
            ),
          ),
        if (saved)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              AppStrings.reportSaveSuccess,
              style: TextStyle(color: AppColors.seedColor.primary),
            ),
          ),
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
        if (!isSearching && suggestions.isNotEmpty)
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
        const SizedBox(height: 16),
        detailsField(
          AppStrings.workDetails,
          (detail) => setState(() => details = detail),
          _detailFocus,
          () => FocusScope.of(context).requestFocus(_priceFocus),
        ),
        const SizedBox(height: 16),
        priceField(
          AppStrings.priceGs,
          (p) => setState(() => price = p),
          _priceFocus,
          () {},
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Text(AppStrings.completed)),
            Checkbox(
              value: isCompleted,
              onChanged: (bool? value) => setState(() => isCompleted = value!),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: Text(AppStrings.paid)),
            Checkbox(
              value: isPaid,
              onChanged: (bool? value) => setState(() => isPaid = value!),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: SizedBox(
            width: 200,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _saveReport(user),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppStrings.saveReport,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
