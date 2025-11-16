import 'package:flutter/material.dart';

SizedBox saveActionButton(
  BuildContext? context,
  String label,
  Function(BuildContext? context) action,
) {
  return SizedBox(
    width: 120,
    child: FloatingActionButton(
      onPressed: () {
        action(context);
      },
      child: Text(label),
    ),
  );
}
