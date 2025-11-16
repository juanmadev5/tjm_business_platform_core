import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tjm_business_platform/core/app_settings.dart';

TextField priceField(String label, Function(String value) setPrice) {
  return TextField(
    keyboardType: .number,
    maxLength: 21,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      TextInputFormatter.withFunction((oldValue, newValue) {
        if (newValue.text.isEmpty) return newValue;

        final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
        final number = int.parse(digitsOnly);

        final newText = AppSettings.formatter.format(number);
        return TextEditingValue(
          text: newText,
          selection: .collapsed(offset: newText.length),
        );
      }),
    ],
    onChanged: (value) {
      setPrice(value);
    },
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.attach_money),
      labelText: label,
      border: OutlineInputBorder(),
    ),
  );
}
