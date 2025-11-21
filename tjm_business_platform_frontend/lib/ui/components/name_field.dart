import 'package:flutter/material.dart';

TextField nameField(
  String label,
  Function(String value) setValue,
  FocusNode focusNode,
  Function() onSubmitted,
  TextEditingController nameController,
  BuildContext context,
  bool readOnly,
) {
  var colors = Theme.of(context).colorScheme;
  return TextField(
    readOnly: readOnly,
    enabled: !readOnly,
    controller: nameController,
    focusNode: focusNode,
    maxLength: 40,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.person, color: colors.primary),
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
    ),
    onChanged: (value) {
      setValue(value);
    },
    onSubmitted: (_) {
      onSubmitted();
    },
  );
}
