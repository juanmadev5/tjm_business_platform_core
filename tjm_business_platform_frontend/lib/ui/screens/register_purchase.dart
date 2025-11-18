import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/core/app_settings.dart';
import 'package:tjm_business_platform/core/app_strings.dart';
import 'package:tjm_business_platform_logic/core/model/expense.dart';
import 'package:tjm_business_platform_logic/domain/data.dart';
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

  final Data data = Data();
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

    final result = await data.appDatabase.addNewExpense(newExpense);

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
      appBar: AppBar(title: Text(AppStrings.registerPurchase)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (error)
              Text(
                "Error al guardar. Verifica los campos.",
                style: TextStyle(color: AppColors.seedColor.error),
              ),
            if (saved)
              Text(
                "Compra registrada correctamente",
                style: TextStyle(color: AppColors.seedColor.primary),
              ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nombre del gasto"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _detailController,
              decoration: InputDecoration(labelText: "Detalle"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Cantidad"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Precio por unidad"),
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
                    selection: .collapsed(offset: newText.length),
                  );
                }),
              ],
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveExpense,
                child: Text("Guardar compra"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
