import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/di/service_locator.dart';
import 'package:coffix_app/core/theme/typography.dart';
import 'package:coffix_app/features/products/data/model/modifier.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:coffix_app/features/products/logic/modifier_cubit.dart';
import 'package:coffix_app/features/products/logic/product_modifier_cubit.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_card.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:coffix_app/presentation/atoms/app_loading.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:coffix_app/presentation/organisms/app_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Map<String, List<Modifier>> _groupModifiersByGroupId(List<Modifier> modifiers) {
  final map = <String, List<Modifier>>{};
  for (final m in modifiers) {
    final key = m.groupId ?? '';
    map.putIfAbsent(key, () => []).add(m);
  }
  return map;
}

class CustomizeProductPage extends StatelessWidget {
  static String route = 'customize_product_route';
  const CustomizeProductPage({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ModifierCubit>()),
        BlocProvider.value(value: getIt<ProductModifierCubit>()),
      ],
      child: CustomizeProductView(product: product),
    );
  }
}

class CustomizeProductView extends StatefulWidget {
  const CustomizeProductView({super.key, required this.product});
  final Product product;

  @override
  State<CustomizeProductView> createState() => _CustomizeProductViewState();
}

class _CustomizeProductViewState extends State<CustomizeProductView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Customize Product", style: theme.textTheme.titleLarge),
      ),
      body: BlocBuilder<ModifierCubit, ModifierState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => AppLoading(),
            loaded: (modifiers) {
              final byGroup = _groupModifiersByGroupId(modifiers);

              return BlocBuilder<ProductModifierCubit, ProductModifierState>(
                builder: (context, productModifierState) {
                  return SingleChildScrollView(
                    padding: AppSizes.defaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppLocation(),
                        ...byGroup.entries.map((e) {
                          final groupId = e.key;
                          final items = e.value;
                          final groupTitle = groupId.isEmpty
                              ? 'Options'
                              : groupId;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  groupTitle,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.md),
                                Wrap(
                                  spacing: AppSizes.sm,
                                  runSpacing: AppSizes.sm,
                                  children: items.map((mod) {
                                    final isSelected = productModifierState
                                        .modifiers
                                        .any(
                                          (modifier) =>
                                              modifier.groupId == groupId &&
                                              modifier.docId == mod.docId,
                                        );

                                    final priceText =
                                        mod.priceDelta != null &&
                                            mod.priceDelta != 0
                                        ? '(+\$${mod.priceDelta!.toStringAsFixed(2)})'
                                        : '';
                                    return AppClickable(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.md,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<ProductModifierCubit>()
                                            .selectModifiers(modifier: mod);
                                      },
                                      child: AppCard(
                                        color: isSelected
                                            ? AppColors.primary.withValues(
                                                alpha: AppSizes.opacityDisabled,
                                              )
                                            : null,
                                        borderColor: isSelected
                                            ? AppColors.primary.withValues()
                                            : null,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSizes.md,
                                          vertical: AppSizes.sm,
                                        ),
                                        child: Text(
                                          '${mod.label ?? ''} $priceText',
                                          style: AppTypography.bodyXS
                                              .copyWith(),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: AppSizes.lg),
                        AppButton.primary(
                          label:
                              "Update \$${productModifierState.totalPrice.toStringAsFixed(2)}",
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(height: AppSizes.xxl),
                      ],
                    ),
                  );
                },
              );
            },
            error: (message) =>
                AppError(title: "Failed getting modifiers", subtitle: message),
          );
        },
      ),
    );
  }
}
