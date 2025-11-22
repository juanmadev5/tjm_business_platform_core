import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_settings.dart';
import 'package:tjm_business_platform/ui/screens/login_screen.dart';

class TJMPlatformApp extends StatelessWidget {
  const TJMPlatformApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppSettings.appName,
      theme: AppSettings.themeLight,
      darkTheme: AppSettings.themeDark,
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}
