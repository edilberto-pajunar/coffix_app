import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/payment/presentation/pages/payment_page.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_card.dart';
import 'package:coffix_app/presentation/atoms/app_icon_button.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderPage extends StatelessWidget {
  static String route = 'order_route';
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderView();
  }
}

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const totalPrice = '\$100.00';
    return Scaffold(
      appBar: AppBar(title: Text("Order", style: theme.textTheme.titleLarge)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSizes.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppLocation(),
                  const SizedBox(height: AppSizes.lg),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _OrderItemRow(
                        name: 'Americano',
                        variant: 'Large',
                        price: '\$10.00',
                        onRemove: () {},
                        onEdit: () {},
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: 10,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.xxl,
                AppSizes.md,
                AppSizes.xxl,
                AppSizes.lg,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(top: BorderSide(color: AppColors.borderColor)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: theme.textTheme.titleMedium),
                      Text(
                        totalPrice,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.md),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton.primary(
                          onPressed: () {
                            context.pushNamed(PaymentPage.route);
                          },
                          label: 'Pay',
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),

                      Expanded(
                        child: AppButton.outlined(
                          onPressed: () {},
                          label: 'Save as draft',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({
    required this.name,
    required this.variant,
    required this.price,
    required this.onRemove,
    required this.onEdit,
  });

  final String name;
  final String variant;
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
          child: SizedBox(
            width: 56,
            height: 56,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.softGrey,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name, style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSizes.xs),
              Text(
                variant,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.lightGrey,
                ),
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
