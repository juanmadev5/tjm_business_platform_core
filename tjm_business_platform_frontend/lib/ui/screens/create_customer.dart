import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/core/is_desktop.dart';
import 'package:tjm_business_platform/state/customer_controller.dart';
import 'package:tjm_business_platform/ui/components/app_button.dart';
import 'package:tjm_business_platform/ui/components/status_message.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final CustomerController _controller = CustomerController();

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
      email: _emailController.text,
      works: [],
    );

    final result = await _controller.addCustomer(newCustomer);

    if (!mounted) return;

    if (result == ActionResult.ok) {
      setState(() {
        error = false;
        saved = true;
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
      });
    } else {
      setState(() => error = true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !isDesktop(context)
          ? AppBar(title: Text(AppStrings.registerCustomer))
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final content = _formContent();

          if (isDesktop(context)) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  margin: const EdgeInsets.all(32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black26,
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

  Widget _formContent() {
    var colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (error)
          actionMessage(
            text: AppStrings.errorOnSaveCustomer,
            color: colors.error,
            icon: Icons.warning_amber_rounded,
          ),
        if (saved) ...[
          actionMessage(
            text: AppStrings.customerSaveSuccess,
            color: colors.primary,
            icon: Icons.check_circle_rounded,
          ),
          SizedBox(height: 12),
        ],
        _textField(
          controller: _nameController,
          label: AppStrings.customerName,
          icon: Icons.person,
        ),
        const SizedBox(height: 16),
        _textField(
          controller: _phoneController,
          label: AppStrings.phoneNumber,
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _textField(
          controller: _emailController,
          label: AppStrings.email,
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 32),
        Center(
          child: SizedBox(
            width: 200,
            height: 48,
            child: AppButton(
              onPressed: _saveCustomer,
              icon: Icons.save,
              text: AppStrings.saveCustomer,
            ),
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
