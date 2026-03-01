import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/order/data/model/order.dart';
import 'package:coffix_app/presentation/molecules/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderActivity extends StatelessWidget {
  const OrderActivity({super.key, required this.orders, this.maxItems = 3});

  final List<Order> orders;
  final int maxItems;

  static List<Order> _filterNeeded(List<Order> orders, int max) {
    return orders
        .where((o) => o.orderStatus != OrderStatus.cancelled)
        .take(max)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final needed = _filterNeeded(orders, maxItems);
    if (needed.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Order activity',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: needed.length > maxItems ? maxItems : needed.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
          itemBuilder: (context, index) =>
              _OrderActivityCard(order: needed[index]),
        ),
      ],
    );
  }
}

const _orderStatusConfig = [
  (OrderStatus.draft, 'Draft', AppColors.lightGrey),
  (OrderStatus.pendingPayment, 'Pending', AppColors.lightGrey),
  (OrderStatus.confirmed, 'Confirmed', AppColors.primary),
  (OrderStatus.preparing, 'Preparing', AppColors.primary),
  (OrderStatus.ready, 'Ready', AppColors.success),
  (OrderStatus.completed, 'Completed', AppColors.success),
  (OrderStatus.cancelled, 'Cancelled', AppColors.error),
];

(String, Color) _orderStatusStyle(OrderStatus? status) {
  if (status == null) return ('—', AppColors.lightGrey);
  for (final e in _orderStatusConfig) {
    if (e.$1 == status) return (e.$2, e.$3);
  }
  return ('—', AppColors.lightGrey);
}

class _OrderActivityCard extends StatelessWidget {
  const _OrderActivityCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = order.scheduledAt ?? order.createdAt;
    final dateStr = date != null
        ? DateFormat('MMM d, h:mm a').format(date)
        : '—';
    final (statusLabel, statusColor) = _orderStatusStyle(order.orderStatus);

    String getLast6(String? value) {
      if (value == null || value.isEmpty) return '—';
      return value.length <= 6 ? value : value.substring(value.length - 6);
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.md),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order: ${getLast6(order.orderNumber)}",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                StatusChip(label: statusLabel, color: statusColor),
                const SizedBox(height: AppSizes.xs),
                Text(
                  dateStr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.lightGrey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${order.total?.toStringAsFixed(2) ?? '0.00'}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
