import 'package:flutter/material.dart';

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
    return const Placeholder();
  }
}
