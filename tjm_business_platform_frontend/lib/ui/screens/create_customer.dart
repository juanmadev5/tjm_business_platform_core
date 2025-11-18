import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';
import 'package:tjm_business_platform_logic/core/model/customer.dart';
import 'package:tjm_business_platform_logic/core/action_result.dart';
import 'package:uuid/uuid.dart';

class CreateCustomer extends StatefulWidget {
  const CreateCustomer({super.key});

  @override
  State<CreateCustomer> createState() => _CreateCustomerState();
}

class _CreateCustomerState extends State<CreateCustomer> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final Data data = Data();

  bool error = false;
  bool saved = false;

  Future<void> _saveCustomer() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      setState(() => error = true);
      return;
    }

    final newCustomer = Customer(
      id: Uuid().v4(),
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      works: [],
    );

    final result = await data.appDatabase.addNewCustomer(newCustomer);

    if (!mounted) return;

    if (result == ActionResult.ok) {
      setState(() {
        error = false;
        saved = true;
        _nameController.clear();
        _phoneController.clear();
      });
    } else {
      setState(() => error = true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.registerCustomer)),
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
