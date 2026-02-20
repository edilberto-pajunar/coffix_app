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
    this.prefixIcon,
    this.suffixIcon,
    this.disabled = false,
  });

  final AppButtonVariant variant;
  final VoidCallback onPressed;
  final String label;
  final Color textColor;
  final Color? borderColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool disabled;

  factory AppButton.primary({
    required VoidCallback onPressed,
    required String label,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool disabled = false,
  }) {
    return AppButton(
      variant: AppButtonVariant.primary,
      onPressed: onPressed,
      label: label,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      disabled: disabled,
    );
  }

  factory AppButton.secondary({
    required VoidCallback onPressed,
    required String label,
    Color textColor = AppColors.white,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool disabled = false,
  }) {
    return AppButton(
      variant: AppButtonVariant.secondary,
      onPressed: onPressed,
      label: label,
      textColor: textColor,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      disabled: disabled,
    );
  }

  factory AppButton.outlined({
    required VoidCallback onPressed,
    required String label,
    Color? borderColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool disabled = false,
  }) {
    return AppButton(
      variant: AppButtonVariant.outlined,
      onPressed: onPressed,
      label: label,
      textColor: AppColors.black,
      borderColor: borderColor,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      disabled: disabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final BoxDecoration decoration = switch (variant) {
      AppButtonVariant.primary => BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.md),
        color: disabled ? AppColors.lightGrey : AppColors.primary,
        boxShadow: [AppColors.shadow],
      ),
      AppButtonVariant.secondary => BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.md),
        color: AppColors.white,
        boxShadow: [AppColors.shadow],
      ),
      AppButtonVariant.outlined => BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.md),
        color: AppColors.white,
        border: Border.all(
          width: 1,
          color: disabled
              ? AppColors.softGrey
              : borderColor ?? AppColors.borderColor,
        ),
        boxShadow: [AppColors.shadow],
      ),
    };

    final borderRadius = BorderRadius.circular(AppSizes.md);
    return AppClickable(
      disabled: disabled,
      onPressed: onPressed,
      borderRadius: borderRadius,
      showSplash: !disabled,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
        decoration: decoration,
        alignment: Alignment.center,
        child: prefixIcon != null || suffixIcon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: AppSizes.sm),
                  ],
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: textColor,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: AppSizes.sm),
                    suffixIcon!,
                  ],
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
