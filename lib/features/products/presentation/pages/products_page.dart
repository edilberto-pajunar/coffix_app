import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/products/presentation/pages/add_product_page.dart';
import 'package:coffix_app/features/products/presentation/pages/customize_product_page.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:coffix_app/presentation/atoms/app_field.dart';
import 'package:coffix_app/presentation/atoms/app_icon_button.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatelessWidget {
  static String route = 'products_route';
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProductView();
  }
}

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Products", style: theme.textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: AppSizes.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppLocation(),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: AppField(hintText: "Product Search", name: "search"),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            Text("Please select your preferred loaction:"),
            const SizedBox(height: AppSizes.lg),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return AppClickable(
                  showSplash: false,
                  onPressed: () {
                    context.pushNamed(AddProductPage.route);
                  },
                  child: Row(
                    children: [
                      CircleAvatar(radius: AppSizes.iconSizeLarge),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Text(
                          "Americano",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "\$10.00",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: 10,
            ),
          ],
        ),
      ),
    );
  }
}
