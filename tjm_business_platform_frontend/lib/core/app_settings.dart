import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppSettings {
  // desktop specific window size
  static final double width = 1200;
  static final double height = 720;

  static final String appName = "TJM Business Platform";
  static final String companyLogoAsset = "assets/images/business_logo.jpg";
  static final priceFormat = NumberFormat("#,###", "es_PY");

  // go to https://material-foundation.github.io/material-theme-builder/ to get custom colors
  static final themeLight = ThemeData(colorScheme: lightScheme());

  static final themeDark = ThemeData(colorScheme: darkScheme());

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00687a),
      surfaceTint: Color(0xff00687a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffabedff),
      onPrimaryContainer: Color(0xff004e5c),
      secondary: Color(0xff4b6269),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffcee7ef),
      onSecondaryContainer: Color(0xff334a51),
      tertiary: Color(0xff565d7e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffdde1ff),
      onTertiaryContainer: Color(0xff3f4565),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff5fafc),
      onSurface: Color(0xff171c1e),
      onSurfaceVariant: Color(0xff3f484b),
      outline: Color(0xff70797b),
      outlineVariant: Color(0xffbfc8cb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3133),
      inversePrimary: Color(0xff84d2e6),
      primaryFixed: Color(0xffabedff),
      onPrimaryFixed: Color(0xff001f26),
      primaryFixedDim: Color(0xff84d2e6),
      onPrimaryFixedVariant: Color(0xff004e5c),
      secondaryFixed: Color(0xffcee7ef),
      onSecondaryFixed: Color(0xff061f24),
      secondaryFixedDim: Color(0xffb2cbd2),
      onSecondaryFixedVariant: Color(0xff334a51),
      tertiaryFixed: Color(0xffdde1ff),
      onTertiaryFixed: Color(0xff131937),
      tertiaryFixedDim: Color(0xffbfc4eb),
      onTertiaryFixedVariant: Color(0xff3f4565),
      surfaceDim: Color(0xffd5dbdd),
      surfaceBright: Color(0xfff5fafc),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff4f6),
      surfaceContainer: Color(0xffe9eff1),
      surfaceContainerHigh: Color(0xffe4e9eb),
      surfaceContainerHighest: Color(0xffdee3e5),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff84d2e6),
      surfaceTint: Color(0xff84d2e6),
      onPrimary: Color(0xff003640),
      primaryContainer: Color(0xff004e5c),
      onPrimaryContainer: Color(0xffabedff),
      secondary: Color(0xffb2cbd2),
      onSecondary: Color(0xff1d343a),
      secondaryContainer: Color(0xff334a51),
      onSecondaryContainer: Color(0xffcee7ef),
      tertiary: Color(0xffbfc4eb),
      onTertiary: Color(0xff282f4d),
      tertiaryContainer: Color(0xff3f4565),
      onTertiaryContainer: Color(0xffdde1ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0f1416),
      onSurface: Color(0xffdee3e5),
      onSurfaceVariant: Color(0xffbfc8cb),
      outline: Color(0xff899295),
      outlineVariant: Color(0xff3f484b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inversePrimary: Color(0xff00687a),
      primaryFixed: Color(0xffabedff),
      onPrimaryFixed: Color(0xff001f26),
      primaryFixedDim: Color(0xff84d2e6),
      onPrimaryFixedVariant: Color(0xff004e5c),
      secondaryFixed: Color(0xffcee7ef),
      onSecondaryFixed: Color(0xff061f24),
      secondaryFixedDim: Color(0xffb2cbd2),
      onSecondaryFixedVariant: Color(0xff334a51),
      tertiaryFixed: Color(0xffdde1ff),
      onTertiaryFixed: Color(0xff131937),
      tertiaryFixedDim: Color(0xffbfc4eb),
      onTertiaryFixedVariant: Color(0xff3f4565),
      surfaceDim: Color(0xff0f1416),
      surfaceBright: Color(0xff343a3c),
      surfaceContainerLowest: Color(0xff090f11),
      surfaceContainerLow: Color(0xff171c1e),
      surfaceContainer: Color(0xff1b2022),
      surfaceContainerHigh: Color(0xff252b2d),
      surfaceContainerHighest: Color(0xff303638),
    );
  }
}
