import 'package:flutter/material.dart';
import 'package:statefulclickcounter/theme/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: Colors.white,
        onSurface: AppColors.text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: 'Lexend',
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
      primaryTextTheme: base.primaryTextTheme.apply(
        fontFamily: 'Lexend',
      ),
    );
  }
}
