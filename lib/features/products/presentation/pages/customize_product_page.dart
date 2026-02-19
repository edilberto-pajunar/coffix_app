import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_card.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomizeProductPage extends StatelessWidget {
  static String route = 'customize_product_route';
  const CustomizeProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomizeProductView();
  }
}

class CustomizeProductView extends StatelessWidget {
  const CustomizeProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Customize Product", style: theme.textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: AppSizes.defaultPadding,
        child: Column(
          children: [
            AppLocation(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Size",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Wrap(
                  spacing: AppSizes.sm,
                  children: [
                    AppClickable(
                      child: AppCard(child: Text("Large")),
                      onPressed: () {},
                    ),
                    AppClickable(
                      child: AppCard(child: Text("Regular")),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            AppButton.primary(
              label: "Update \$6.00",
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
