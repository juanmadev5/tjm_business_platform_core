import 'package:flutter/material.dart';

TextField detailsField(
  String label,
  Function(String detail) setDetail,
  FocusNode focusNode,
  Function() onSubmitted,
) {
  return TextField(
    focusNode: focusNode,
    maxLines: 10,
    decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    onChanged: (value) {
      setDetail(value);
    },
    onSubmitted: (_) {
      onSubmitted();
    },
  );
}
