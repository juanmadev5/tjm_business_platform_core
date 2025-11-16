import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/core/strings.dart';

void actionSnackbar(
  BuildContext context,
  bool success,
  String actionSuccessLabel,
) {
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: .floating,
        width: 180,
        content: Center(
          child: Text(
            actionSuccessLabel,
            style: TextStyle(color: AppColors.seedColor.onSurface),
          ),
        ),
        backgroundColor: AppColors.seedColor.onSecondary,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: .floating,
        width: 280,
        content: Center(
          child: Text(
            AppStrings.completeAllFields,
            style: TextStyle(color: AppColors.seedColor.onSurface),
          ),
        ),
        backgroundColor: AppColors.seedColor.onSecondary,
      ),
    );
  }
}
