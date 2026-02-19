import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/products/presentation/pages/customize_product_page.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_card.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:coffix_app/presentation/atoms/app_icon.dart';
import 'package:coffix_app/presentation/atoms/app_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddProductPage extends StatelessWidget {
  static String route = 'add_product_route';
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddProductView();
  }
}

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Americano", style: theme.textTheme.titleLarge),
      ),
      body: Padding(
        padding: AppSizes.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(child: CircleAvatar(radius: AppSizes.iconSizeXLarge)),
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
                    onPressed: () {},
                    borderRadius: BorderRadius.circular(AppSizes.md),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppIconButton.withIconData(
                          Icons.settings,
                          size: AppSizes.iconSizeLarge,
                          color: AppColors.primary,
                          onPressed: () {
                            context.pushNamed(CustomizeProductPage.route);
                          },
                          borderColor: Colors.transparent,
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
                            onPressed: () {},
                            borderRadius: BorderRadius.circular(AppSizes.sm),
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
                                Icons.remove,
                                size: AppSizes.iconSizeSmall,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          Container(
                            constraints: const BoxConstraints(minWidth: 40),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                              vertical: AppSizes.sm,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "1",
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          AppClickable(
                            onPressed: () {},
                            borderRadius: BorderRadius.circular(AppSizes.sm),
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
            const SizedBox(height: AppSizes.lg),
            Spacer(),
            Text(
              textAlign: TextAlign.center,
              "\$5.00",
              style: theme.textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            AppButton(
              onPressed: () {},
              label: "Add to Order",
              prefixIcon: AppIcon.withIconData(
                Icons.add,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }
}
