import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/theme/typography.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.titleXL,
      scrolledUnderElevation: 0,
    ),
    fontFamily: "Inter",
    textTheme: TextTheme(),
  );
}
