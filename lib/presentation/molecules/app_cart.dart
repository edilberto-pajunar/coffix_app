import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/cart/logic/cart_cubit.dart';
import 'package:coffix_app/features/order/presentation/pages/order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppCart extends StatelessWidget {
  const AppCart({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartCubit>().state.cart?.items;

    return Padding(
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
    );
  }
}
