import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.variant = AppButtonVariant.primary,
    required this.onPressed,
    required this.label,
    this.textColor = AppColors.white,
    this.borderColor,
    this.suffixIcon,
  });

  final AppButtonVariant variant;
  final VoidCallback? onPressed;
  final String label;
  final Color textColor;
  final Color? borderColor;
  final Widget? suffixIcon;

  factory AppButton.primary({
    required VoidCallback? onPressed,
    required String label,
    Widget? suffixIcon,
  }) {
    return AppButton(
      variant: AppButtonVariant.primary,
      onPressed: onPressed,
      label: label,
      suffixIcon: suffixIcon,
    );
  }

  factory AppButton.secondary({
    required VoidCallback? onPressed,
    required String label,
    Color textColor = AppColors.white,
    Widget? suffixIcon,
  }) {
    return AppButton(
      variant: AppButtonVariant.secondary,
      onPressed: onPressed,
      label: label,
      textColor: textColor,
      suffixIcon: suffixIcon,
    );
  }

  factory AppButton.outlined({
    required VoidCallback? onPressed,
    required String label,
    Color? borderColor,
    Widget? suffixIcon,
  }) {
    return AppButton(
      variant: AppButtonVariant.outlined,
      onPressed: onPressed,
      label: label,
      borderColor: borderColor,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null;

    final BoxDecoration decoration = switch (variant) {
      AppButtonVariant.primary => BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.md),
        color: AppColors.primary,
      ),
      AppButtonVariant.secondary => BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.md),
        color: AppColors.white,
      ),
      AppButtonVariant.outlined => BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.md),
        border: Border.all(
          width: 1,
          color: borderColor ?? AppColors.borderColor,
        ),
      ),
    };

    final borderRadius = BorderRadius.circular(AppSizes.md);
    return AppClickable(
      onPressed: onPressed ?? () {},
      disabled: !enabled,
      borderRadius: borderRadius,
      showSplash: enabled,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        decoration: decoration,
        alignment: Alignment.center,
        child: suffixIcon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  suffixIcon!,
                ],
              )
            : Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
              ),
      ),
    );
  }
}
