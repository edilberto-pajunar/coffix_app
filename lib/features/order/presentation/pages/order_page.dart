import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/di/service_locator.dart';
import 'package:coffix_app/features/cart/logic/cart_cubit.dart';
import 'package:coffix_app/features/order/presentation/pages/schedule_order_page.dart';
import 'package:coffix_app/features/order/presentation/widgets/order_item.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/molecules/app_back_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderPage extends StatelessWidget {
  static String route = 'order_route';
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartCubit>(),
      child: const OrderView(),
    );
  }
}

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSizes.defaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppBackHeader(title: "Order", showBackButton: false,),
                      const SizedBox(height: AppSizes.lg),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final cartItem = state.cart?.items[index];
                          if (cartItem == null) return const SizedBox.shrink();
                          return OrderItemRow(
                            cartItem: cartItem,
                            price: '\$${cartItem.lineTotal}',
                            onRemove: () {
                              context.read<CartCubit>().removeProduct(
                                cartItemId: cartItem.id,
                              );
                            },
                            onEdit: () {},
                          );
                        },
                        separatorBuilder: (_, _) => const Divider(),
                        itemCount: state.cart?.items.length ?? 0,
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  padding: AppSizes.defaultPadding,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(color: AppColors.borderColor),
                    ),
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
                            '\$${state.cart?.items.fold(0.0, (sum, item) => sum + item.lineTotal) ?? 0}',
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
                              disabled: state.cart?.items.isEmpty ?? true,
                              onPressed: () {
                                context.pushNamed(ScheduleOrderPage.route);
                              },
                              label: 'Next',
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),

                          Expanded(
                            child: AppButton.outlined(
                              disabled: state.cart?.items.isEmpty ?? true,
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
          );
        },
      ),
    );
  }
}
