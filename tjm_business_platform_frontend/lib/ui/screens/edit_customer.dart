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

      Navigator.pop(context, true); // Indicar que se editó
    } else {
      setState(() => error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.editCustomer)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          final content = _formContent();

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
                    padding: const EdgeInsets.all(32),
                    child: content,
                  ),
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: content,
            );
          }
        },
      ),
    );
  }

  Widget _formContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (error)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              AppStrings.errorOnSaveCustomer,
              style: TextStyle(color: AppColors.seedColor.error),
            ),
          ),
        if (saved)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              AppStrings.customerSaveSuccess,
              style: TextStyle(color: AppColors.seedColor.primary),
            ),
          ),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: AppStrings.customerName),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(labelText: AppStrings.phoneNumber),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 32),
        Center(
          child: SizedBox(
            width: 200,
            height: 48,
            child: ElevatedButton(
              onPressed: _saveCustomer,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppStrings.saveCustomer,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
