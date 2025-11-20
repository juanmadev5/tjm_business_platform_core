import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tjm_business_platform/core/app_settings.dart';

TextField priceField(
  String label,
  Function(String value) setPrice,
  FocusNode focusNode,
  Function() onSubmitted, {
  TextEditingController? controller,
  required BuildContext context,
}) {
  return TextField(
    controller: controller,
    focusNode: focusNode,
    keyboardType: .number,
    maxLength: 21,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      TextInputFormatter.withFunction((oldValue, newValue) {
        if (newValue.text.isEmpty) return newValue;

        final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
        final number = int.parse(digitsOnly);

        final newText = AppSettings.priceFormat.format(number);
        return TextEditingValue(
          text: newText,
          selection: .collapsed(offset: newText.length),
        );
      }),
    ],
    onChanged: (value) {
      setPrice(value);
    },
    onSubmitted: (_) {
      onSubmitted();
    },
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
    ),
  );
}
