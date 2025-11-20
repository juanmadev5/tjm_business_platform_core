import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/state/customer_controller.dart';
import 'package:tjm_business_platform/ui/components/app_button.dart';
import 'package:tjm_business_platform/ui/components/responsive_layout.dart';
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
  late TextEditingController _emailController;

  final CustomerController _controller = CustomerController();
  bool error = false;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _phoneController = TextEditingController(text: widget.customer.phoneNumber);
    _emailController = TextEditingController(text: widget.customer.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _deleteCustomer() async {
    final result = await _controller.deleteCustomer(widget.customer.id);

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

  Future<void> _saveCustomer() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      setState(() => error = true);
      return;
    }

    final updatedCustomer = Customer(
      id: widget.customer.id,
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      works: widget.customer.works,
    );

    final result = await _controller.editCustomer(updatedCustomer);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.editCustomer)),
      body: ResponsiveLayout(
        mobileBody: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _formContent(),
        ),
        desktopBody: Center(
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
                child: _formContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formContent() {
    var colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (error)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              AppStrings.errorOnSaveCustomer,
              style: TextStyle(color: colors.error),
            ),
          ),
        if (saved)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              AppStrings.customerSaveSuccess,
              style: TextStyle(color: colors.primary),
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
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: AppStrings.email),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton(text: AppStrings.saveCustomer, onPressed: _saveCustomer),
            const SizedBox(width: 8),
            AppButton(
              text: AppStrings.deleteCustomer,
              onPressed: _deleteCustomer,
            ),
          ],
        ),
      ],
    );
  }
}
