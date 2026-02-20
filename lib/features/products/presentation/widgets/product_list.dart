import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/theme/typography.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:coffix_app/features/products/data/model/product_category.dart';
import 'package:coffix_app/features/products/presentation/pages/add_product_page.dart';
import 'package:coffix_app/presentation/atoms/app_card.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:coffix_app/presentation/atoms/app_field.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.products,
    required this.productCategories,
  });

  final List<Product> products;
  final List<ProductCategory> productCategories;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          SizedBox(
            height: AppSizes.chipSizeSmall,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: productCategories.length,
              separatorBuilder: (_, index) =>
                  const SizedBox(width: AppSizes.md),
              itemBuilder: (context, index) {
                final category = productCategories[index];
                return AppCard(
                  color: AppColors.white,
                  child: Text(category.name ?? "", style: AppTypography.labelS),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final product = products[index];
              return AppClickable(
                showSplash: false,
                onPressed: () {
                  context.pushNamed(AddProductPage.route, extra: {
                    "product": product,
                  });
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.md),
                      child: Image.network(
                        product.imageUrl ?? "",
                        width: AppSizes.iconSizeXLarge,
                        height: AppSizes.iconSizeXLarge,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        product.name ?? "",
                        style: AppTypography.labelS,
                      ),
                    ),
                    Text(
                      "\$${product.price ?? 0}",
                      style: AppTypography.labelS.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, _) => const Divider(),
            itemCount: products.length,
          ),
        ],
      ),
    );
  }
}
