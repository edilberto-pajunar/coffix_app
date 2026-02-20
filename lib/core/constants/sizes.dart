import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double xxxxl = 40.0;
  static const double xxxxxl = 48.0;

  static const double opacityDisabled = 0.5;
  static const double opacityEnabled = 1.0;
  static const double opacityDisabledText = 0.2;

  static const double iconSizeXxs = 12.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  static const double iconSizeXXLarge = xxxxl * 8; // 320

  // --- Page Padding ---
  static const defaultPadding = EdgeInsetsDirectional.only(
    start: AppSizes.xxl,
    end: AppSizes.xxl,
    top: AppSizes.xl,
    bottom: AppSizes.lg,
  );
}
