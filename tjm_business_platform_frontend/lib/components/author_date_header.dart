import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/strings.dart';
import 'package:tjm_business_platform/data/provider.dart';

Column authorDateHeader() {
  Provider provider = Provider();

  return Column(
    crossAxisAlignment: .start,
    children: [
      Text("${AppStrings.author} ${provider.name}"),
      SizedBox(height: 8),
      Text("${AppStrings.date} ${provider.getTodayDate()}"),
      SizedBox(height: 16),
    ],
  );
}
