import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
    this.padding,
  });

  final Widget child;
  final Color? color;
  final Color? borderColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color:
            color ??
            AppColors.white.withValues(alpha: AppSizes.opacityDisabledText),
        borderRadius: BorderRadius.circular(AppSizes.md),
        border: Border.all(
          width: 1.21,
          color: borderColor ?? AppColors.borderColor,
        ),
      ),
      child: child,
    );
  }
}
