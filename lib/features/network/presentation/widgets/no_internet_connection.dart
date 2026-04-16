import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const NoInternetConnection(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSizes.sm),
          Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.lightGrey),
          const SizedBox(height: AppSizes.md),
          Text(
            'No Internet Connection',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Please check your connection and try again.',
            style: theme.textTheme.bodyMedium?.copyWith(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
        ],
      ),
    );
  }
}
