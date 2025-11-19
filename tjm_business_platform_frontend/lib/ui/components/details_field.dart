import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';

TextField detailsField(
  String label,
  Function(String detail) setDetail,
  FocusNode focusNode,
  Function() onSubmitted, {
  TextEditingController? controller,
}) {
  return TextField(
    controller: controller,
    focusNode: focusNode,
    maxLines: 10,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.seedColor.primary, width: 2),
      ),
    ),
    onChanged: (value) {
      setDetail(value);
    },
    onSubmitted: (_) {
      onSubmitted();
    },
  );
}
