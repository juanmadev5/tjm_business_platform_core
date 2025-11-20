import 'package:flutter/material.dart';

TextField detailsField(
  String label,
  Function(String detail) setDetail,
  FocusNode focusNode,
  Function() onSubmitted, {
  TextEditingController? controller,
  required BuildContext context
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
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
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
