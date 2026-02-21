import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/di/service_locator.dart';
import 'package:coffix_app/core/extensions/product_extensions.dart';
import 'package:coffix_app/features/order/logic/cart_cubit.dart';
import 'package:coffix_app/features/order/presentation/pages/order_page.dart';
import 'package:coffix_app/features/products/data/model/product_with_category.dart';
import 'package:coffix_app/features/products/logic/modifier_cubit.dart';
import 'package:coffix_app/features/products/logic/product_cubit.dart';
import 'package:coffix_app/features/products/presentation/widgets/product_list.dart';
import 'package:coffix_app/presentation/atoms/app_loading.dart';
import 'package:coffix_app/presentation/organisms/app_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatelessWidget {
  static String route = 'products_route';
  const ProductsPage({super.key, required this.storeId});

  final String storeId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ProductCubit>()),
        BlocProvider.value(value: getIt<ModifierCubit>()),
        BlocProvider.value(value: getIt<CartCubit>()),
      ],
      child: ProductView(storeId: storeId),
    );
  }
}

class ProductView extends StatefulWidget {
  const ProductView({super.key, required this.storeId});

  final String storeId;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartCubit>().state.cart?.items;

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: AppSizes.lg, right: AppSizes.lg),
        child: FloatingActionButton(
          onPressed: () {
            context.goNamed(OrderPage.route);
          },
          child: Badge(
            label: Text('${cartItems?.length ?? 0}'),
            child: Icon(Icons.shopping_cart),
          ),
        ),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => AppLoading(),
            loaded:
                (List<ProductWithCategory> products, String? categoryFilter) =>
                    ProductList(
                      products: products.productsByStore(widget.storeId),
                    ),
            error: (message) =>
                AppError(title: "Failed getting products", subtitle: message),
          );
        },
      ),
    );
  }
}
