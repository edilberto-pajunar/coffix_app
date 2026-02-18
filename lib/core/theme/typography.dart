import 'package:coffix_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String _fontFamily = 'Inter';

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 57,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 45,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 36,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.black,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}
