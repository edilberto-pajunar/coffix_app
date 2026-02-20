import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/di/service_locator.dart';
import 'package:coffix_app/core/theme/typography.dart';
import 'package:coffix_app/features/order/logic/cart_cubit.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:coffix_app/features/products/logic/modifier_cubit.dart';
import 'package:coffix_app/features/products/logic/product_modifier_cubit.dart';
import 'package:coffix_app/features/products/presentation/pages/customize_product_page.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_card.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:coffix_app/presentation/atoms/app_icon.dart';
import 'package:coffix_app/presentation/organisms/app_layout_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddProductPage extends StatelessWidget {
  static String route = 'add_product_route';
  const AddProductPage({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CartCubit>()),
        BlocProvider.value(value: getIt<ProductModifierCubit>()),
        BlocProvider.value(value: getIt<ModifierCubit>()),
      ],
      child: AddProductView(product: product),
    );
  }
}

class AddProductView extends StatefulWidget {
  const AddProductView({super.key, required this.product});
  final Product product;

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    context.read<ProductModifierCubit>().initProductModifiers(
      product: widget.product,
      allModifiers: context.read<ModifierCubit>().state.maybeWhen(
        loaded: (modifiers) => modifiers,
        orElse: () => [],
      ),
    );
  }

  double calculateTotal() {
    final productModifierState = context.watch<ProductModifierCubit>().state;
    final total =
        widget.product.price! * quantity + productModifierState.totalPrice;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productModifierState = context.watch<ProductModifierCubit>().state;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: AppLayoutBody(
        hasSafeArea: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: AppSizes.productImageSize,
              width: double.infinity,
              child:
                  widget.product.imageUrl != null &&
                      widget.product.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadiusGeometry.vertical(
                        bottom: Radius.circular(AppSizes.lg),
                      ),
                      child: Image.network(
                        widget.product.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      color: AppColors.softGrey,
                      child: const Center(
                        child: Icon(
                          Icons.coffee_rounded,
                          size: 80,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: AppSizes.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSizes.lg),
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.lg,
                      vertical: AppSizes.md,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppClickable(
                          showSplash: false,
                          onPressed: () {
                            context.pushNamed(
                              CustomizeProductPage.route,
                              extra: {'product': widget.product},
                            );
                          },
                          borderRadius: BorderRadius.circular(AppSizes.md),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings,
                                color: AppColors.primary,
                                size: AppSizes.iconSizeLarge,
                              ),
                              const SizedBox(height: AppSizes.xs),
                              Text(
                                "Customise",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Quantity",
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.lightGrey,
                              ),
                            ),
                            const SizedBox(height: AppSizes.sm),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppClickable(
                                  disabled: quantity <= 1,
                                  onPressed: () {
                                    setState(() {
                                      quantity -= 1;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.sm,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: quantity <= 1
                                            ? Colors.transparent
                                            : AppColors.borderColor,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.sm,
                                      ),
                                    ),
                                    child: AppIcon.withIconData(
                                      Icons.remove,
                                      size: AppSizes.iconSizeSmall,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 40,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.md,
                                    vertical: AppSizes.sm,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "$quantity",
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                AppClickable(
                                  onPressed: () {
                                    setState(() {
                                      quantity += 1;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.sm,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.borderColor,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.sm,
                                      ),
                                    ),
                                    child: AppIcon.withIconData(
                                      Icons.add,
                                      size: AppSizes.iconSizeSmall,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.xxl),
                  Wrap(
                    spacing: AppSizes.sm,
                    children: productModifierState.modifiers
                        .map((mod) => AppCard(child: Text(mod.label ?? '')))
                        .toList(),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: AppSizes.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text("Total:"),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.right,
                          widget.product.price != null
                              ? '\$${calculateTotal().toStringAsFixed(2)}'
                              : '\$0.00',
                          style: AppTypography.bodyL.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.lg),
                  AppButton(
                    onPressed: () {
                      final modifierState = context
                          .read<ProductModifierCubit>()
                          .state;
                      final total =
                          widget.product.price! * quantity +
                          modifierState.totalPrice;
                      context.read<CartCubit>().addProduct(
                        product: widget.product,
                        quantity: quantity,
                        storeId: widget.product.availableStores?.first ?? '',
                        total: total,
                        modifiers: modifierState.modifiers,
                      );
                      context.pop();
                    },
                    label: "Add to Order",
                    prefixIcon: AppIcon.withIconData(
                      Icons.add,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }
}
