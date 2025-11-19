import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/core/app_settings.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform/state/expense_controller.dart';
import 'package:tjm_business_platform/ui/components/app_button.dart';
import 'package:tjm_business_platform/ui/components/responsive_layout.dart';
import 'package:tjm_business_platform_logic/core/model/expense.dart';
import 'package:tjm_business_platform_logic/core/action_result.dart';
import 'package:uuid/uuid.dart';
import 'package:tjm_business_platform/ui/utils/currency_format.dart';

class RegisterPurchase extends StatefulWidget {
  const RegisterPurchase({super.key});

  @override
  State<RegisterPurchase> createState() => _RegisterPurchaseState();
}

class _RegisterPurchaseState extends State<RegisterPurchase> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final ExpenseController _controller = ExpenseController();
  bool error = false;
  bool saved = false;

  Future<void> _saveExpense() async {
    if (_nameController.text.isEmpty ||
        _detailController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _priceController.text.isEmpty) {
      setState(() => error = true);
      return;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final price = parseGsToDouble(_priceController.text);

    if (quantity <= 0 || price <= 0) {
      setState(() => error = true);
      return;
    }

    final newExpense = Expense(
      id: Uuid().v4(),
      name: _nameController.text,
      detail: _detailController.text,
      quantity: quantity,
      price: price,
    );

    final result = await _controller.addExpense(newExpense);

    if (!mounted) return;

    if (result == ActionResult.ok) {
      setState(() {
        error = false;
        saved = true;
        _nameController.clear();
        _detailController.clear();
        _quantityController.clear();
        _priceController.clear();
      });
    } else {
      setState(() => error = true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.registerPurchase), elevation: 2),
      body: ResponsiveLayout(
        mobileBody: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _formContent(),
        ),
        desktopBody: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(32),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: _formContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (error)
          _buildStatusMessage(
            text: AppStrings.errorOnSavePurchase,
            color: AppColors.seedColor.error,
            icon: Icons.warning_amber_rounded,
          ),
        if (saved)
          _buildStatusMessage(
            text: AppStrings.purchaseSaveSuccess,
            color: AppColors.seedColor.primary,
            icon: Icons.check_circle_rounded,
          ),
        _buildInput(
          controller: _nameController,
          label: AppStrings.expenseName,
          icon: Icons.shopping_bag_outlined,
        ),
        const SizedBox(height: 16),
        _buildInput(
          controller: _detailController,
          label: AppStrings.expenseDetails,
          icon: Icons.description_outlined,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        _buildInput(
          controller: _quantityController,
          label: AppStrings.quantity,
          icon: Icons.confirmation_number_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        _buildInput(
          controller: _priceController,
          label: AppStrings.unitaryPrice,
          icon: Icons.attach_money_rounded,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.isEmpty) return newValue;

              final digitsOnly = newValue.text.replaceAll(
                RegExp(r'[^0-9]'),
                '',
              );
              final number = int.parse(digitsOnly);

              final newText = AppSettings.priceFormat.format(number);
              return TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length),
              );
            }),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: SizedBox(
            width: 220,
            child: AppButton(
              text: AppStrings.saveExpense,
              onPressed: _saveExpense,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.seedColor.primary),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.seedColor.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildStatusMessage({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
