import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:flutter/material.dart';

class ConfirmAccountDeletion extends StatelessWidget {
  const ConfirmAccountDeletion({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  static Future<bool?> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmAccountDeletion(
        onConfirm: () {
          Navigator.of(context).pop(true);
          onConfirm();
        },
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        'Delete account',
        style: theme.textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Are you sure you want to delete your account? This action cannot be undone.',
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton.outlined(onPressed: onCancel, label: 'Cancel'),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: AppButton.primary(
                onPressed: onConfirm,
                label: 'Delete',
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
