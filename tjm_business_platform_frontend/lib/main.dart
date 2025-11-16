import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/business_specific.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/data/provider.dart';
import 'package:tjm_business_platform/screens/login_screen.dart';
import 'package:tjm_business_platform_logic/data/client/client_loader.dart';
import 'package:window_manager/window_manager.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(1200, 720));
  }
  ClientLoader().initialize(
    supabaseUrl: "url",
    supabaseKey: "key",
  );
  Provider _ = Provider(); //just for test purposes
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: BusinessSpecific.appName,
      theme: ThemeData(colorScheme: AppColors.seedColor),
      themeMode: ThemeMode.dark,
      home: const LoginScreen(),
    );
  }
}
