import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.seedColor.onSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );

    final label = Text(
      text,
      style: TextStyle(fontSize: 16, color: textColor ?? Colors.white),
    );

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon, color: textColor ?? Colors.white),
        label: label,
      );
    }

    return ElevatedButton(onPressed: onPressed, style: style, child: label);
  }
}
