import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';
import 'package:tjm_business_platform_logic/core/model/customer.dart';
import 'package:tjm_business_platform_logic/core/action_result.dart';

class EditCustomer extends StatefulWidget {
  final Customer customer;
  const EditCustomer({super.key, required this.customer});

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  final Data data = Data();
  bool error = false;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _phoneController = TextEditingController(text: widget.customer.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      setState(() => error = true);
      return;
    }

    final updatedCustomer = Customer(
      id: widget.customer.id,
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      works: widget.customer.works,
    );

    final result = await data.appDatabase.editCustomer(updatedCustomer);

    if (!mounted) return;

    if (result == ActionResult.ok) {
      setState(() {
        error = false;
        saved = true;
      });

      // Pop y devolver true para indicar que se editó
      Navigator.pop(context, true);
    } else {
      setState(() => error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.editCustomer)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (error)
              Text(
                AppStrings.errorOnSaveCustomer,
                style: TextStyle(color: AppColors.seedColor.error),
              ),
            if (saved)
              Text(
                AppStrings.customerSaveSuccess,
                style: TextStyle(color: AppColors.seedColor.primary),
              ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: AppStrings.customerName),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: AppStrings.phoneNumber),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveCustomer,
                child: Text(AppStrings.saveCustomer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
