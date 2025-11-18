import 'package:flutter/material.dart';

TextField nameField(
  String label,
  Function(String value) setValue,
  FocusNode focusNode,
  Function() onSubmitted, TextEditingController nameController,
) {
  return TextField(
    controller: nameController,
    focusNode: focusNode,
    maxLength: 40,
    decoration: InputDecoration(labelText: label),
    onChanged: (value) {
      setValue(value);
    },
    onSubmitted: (_) {
      onSubmitted();
    },
  );
}
