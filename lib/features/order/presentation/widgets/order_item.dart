import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/order/data/model/cart_item.dart';
import 'package:coffix_app/presentation/atoms/app_card.dart';
import 'package:coffix_app/presentation/atoms/app_icon_button.dart';
import 'package:flutter/material.dart';

class OrderItemRow extends StatelessWidget {
  const OrderItemRow({
    super.key,
    required this.cartItem,
    required this.price,
    required this.onRemove,
    required this.onEdit,
  });

  final CartItem cartItem;
  final String price;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.md),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Image.network(
                cartItem.product.imageUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${cartItem.product.name} x${cartItem.quantity}",
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: AppSizes.xs),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: cartItem.modifiers
                    .map(
                      (modifier) => AppCard(child: Text(modifier.label ?? '')),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                price,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton.withIconData(
              Icons.edit_outlined,
              onPressed: onEdit,
              size: AppSizes.iconSizeSmall,
              color: AppColors.black,
              borderColor: Colors.transparent,
            ),
            const SizedBox(width: AppSizes.xs),
            AppIconButton.withIconData(
              Icons.close,
              onPressed: onRemove,
              size: AppSizes.iconSizeSmall,
              color: AppColors.black,
              borderColor: Colors.transparent,
            ),
          ],
        ),
      ],
    );
  }
}
