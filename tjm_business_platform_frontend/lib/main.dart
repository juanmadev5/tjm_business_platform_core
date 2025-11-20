import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_settings.dart';
import 'package:tjm_business_platform/ui/screens/login_screen.dart';
import 'package:tjm_business_platform/secrets.dart';
import 'package:tjm_business_platform_logic/data/client/client_loader.dart';
import 'package:window_manager/window_manager.dart';

const double width = 1200;
const double height = 720;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ClientLoader().initialize(
    supabaseUrl: SUPABASE_URL,
    supabaseKey: SUPABASE_KEY,
  );

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();

    const Size windowSize = Size(width, height);
    WindowManager.instance.setTitle(AppSettings.appName);
    WindowManager.instance.setResizable(false);
    WindowManager.instance.setMaximizable(false);
    WindowManager.instance.center();
    WindowManager.instance.setMinimumSize(windowSize);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppSettings.appName,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}
