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
      id: const Uuid().v4(),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          final content = _formContent();

          if (isDesktop) {
            // Centrar y limitar ancho para escritorio
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  margin: const EdgeInsets.all(32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: content,
                  ),
                ),
              ),
            );
          } else {
            // Móvil: scroll normal
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
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
          decoration: InputDecoration(
            labelText: AppStrings.customerName,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: AppStrings.phoneNumber,
            border: const OutlineInputBorder(),
          ),
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
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
