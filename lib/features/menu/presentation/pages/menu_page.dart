import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/molecules/app_header.dart';
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
    return Scaffold(
      body: Padding(
        padding: AppSizes.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [AppHeader(title: "Menu")],
        ),
      ),
    );
  }
}
