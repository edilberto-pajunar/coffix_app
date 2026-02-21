import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  static String route = 'cart_route';
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartView();
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}