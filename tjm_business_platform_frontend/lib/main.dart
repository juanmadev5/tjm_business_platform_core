import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app.dart';
import 'package:tjm_business_platform/core/app_settings.dart';
import 'package:tjm_business_platform/secrets.dart';
import 'package:tjm_business_platform_logic/data/client/client_loader.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ClientLoader().initialize(
    supabaseUrl: SUPABASE_URL,
    supabaseKey: SUPABASE_KEY,
  );

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();

    final Size windowSize = Size(AppSettings.width, AppSettings.height);
    WindowManager.instance.setTitle(AppSettings.appName);
    WindowManager.instance.setResizable(false);
    WindowManager.instance.setMaximizable(false);
    WindowManager.instance.center();
    WindowManager.instance.setMinimumSize(windowSize);
  }
  runApp(const TJMPlatformApp());
}
