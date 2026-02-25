import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/theme/typography.dart';
import 'package:coffix_app/features/menu/presentation/pages/menu_page.dart';
import 'package:coffix_app/features/stores/data/model/store.dart';
import 'package:coffix_app/features/stores/logic/store_cubit.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:coffix_app/presentation/atoms/app_field.dart';
import 'package:coffix_app/presentation/atoms/app_icon_button.dart';
import 'package:coffix_app/presentation/molecules/app_back_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StoreList extends StatelessWidget {
  const StoreList({super.key, required this.stores});

  final List<Store> stores;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSizes.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBackHeader(title: "Stores", showBackButton: false),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: AppField(hintText: "Store Search", name: "search"),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text("Please select your preferred loaction:"),
          const SizedBox(height: AppSizes.lg),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final store = stores[index];
              return AppClickable(
                showSplash: false,
                onPressed: () {
                  context.read<StoreCubit>().updatePreferredStore(
                    storeId: store.docId,
                  );
                  context.goNamed(MenuPage.route);
                  // context.pushNamed(
                  //   ProductsPage.route,
                  //   extra: {'storeId': store.docId},
                  // );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppSizes.iconSizeLarge,
                      backgroundImage: NetworkImage(store.imageUrl ?? ""),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(store.name ?? "", style: AppTypography.labelS),
                          Text(
                            store.address ?? "",
                            style: AppTypography.body2XS.copyWith(
                              color: AppColors.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppIconButton.withIconData(
                      Icons.arrow_forward_ios,
                      onPressed: () {},
                      borderColor: Colors.transparent,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, _) => const Divider(),
            itemCount: stores.length,
          ),
        ],
      ),
    );
  }
}
