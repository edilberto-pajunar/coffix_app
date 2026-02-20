import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  const AppError({
    super.key,
    required this.title,
    required this.subtitle,
    this.onRetry,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSizes.xxl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: AppSizes.iconSizeXLarge,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
            if (onRetry != null) ...[
              AppButton.primary(onPressed: onRetry!, label: 'Retry'),
              const SizedBox(height: AppSizes.xxl),
            ],
          ],
        ),
      ),
    );
  }
}
