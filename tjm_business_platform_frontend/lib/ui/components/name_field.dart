import 'package:flutter/material.dart';

TextField nameField(String label, Function(String value) setValue) {
  return TextField(
    maxLength: 40,
    decoration: InputDecoration(labelText: label),
    onChanged: (value) {
      setValue(value);
    },
  );
}
