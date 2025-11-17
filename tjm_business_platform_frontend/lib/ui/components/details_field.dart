import 'package:flutter/material.dart';

TextField detailsField(String label, Function(String detail) setDetail) {
  return TextField(
    maxLines: 30,
    decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    onChanged: (value) {
      setDetail(value);
    },
  );
}
