import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';

TextField nameField(
  String label,
  Function(String value) setValue,
  FocusNode focusNode,
  Function() onSubmitted,
  TextEditingController nameController,
) {
  return TextField(
    controller: nameController,
    focusNode: focusNode,
    maxLength: 40,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.person, color: AppColors.seedColor.primary),
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.seedColor.primary, width: 2),
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
