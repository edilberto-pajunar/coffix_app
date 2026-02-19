import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String route = 'home_route';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("hello!")));
  }
}
