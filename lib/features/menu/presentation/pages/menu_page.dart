import 'package:coffix_app/features/products/logic/product_cubit.dart';
import 'package:coffix_app/features/products/presentation/widgets/product_list.dart';
import 'package:coffix_app/presentation/atoms/app_loading.dart';
import 'package:coffix_app/presentation/organisms/app_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuPage extends StatelessWidget {
  static String route = 'menu_route';
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MenuView();
  }
}

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => AppLoading(),
            loaded: (products, categoryFilter) => ProductList(
              products: products,
              isRoot: true,
              categoryFilter: categoryFilter,
              storeId: "",
            ),
            error: (message) =>
                AppError(title: "Failed getting products", subtitle: message),
          );
        },
      ),
    );
  }
}
