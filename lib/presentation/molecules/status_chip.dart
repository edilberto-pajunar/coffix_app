import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/transaction/data/model/transaction.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final TransactionStatus? status;

  const StatusChip({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color) = switch (status) {
      TransactionStatus.paid => ('Paid', AppColors.success),
      TransactionStatus.pending => ('Pending', AppColors.primary),
      TransactionStatus.failed => ('Failed', AppColors.error),
      _ => ('—', AppColors.lightGrey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.sm),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
