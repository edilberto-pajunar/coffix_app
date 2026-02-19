import 'dart:async';

import 'package:coffix_app/features/auth/presentation/pages/create_account_page.dart';
import 'package:coffix_app/features/auth/presentation/pages/login_page.dart';
import 'package:coffix_app/features/credit/presentation/pages/credit_page.dart';
import 'package:coffix_app/features/home/presentation/pages/home_page.dart';
import 'package:coffix_app/features/layout/presentation/pages/layout_page.dart';
import 'package:coffix_app/features/menu/presentation/pages/menu_page.dart';
import 'package:coffix_app/features/order/presentation/pages/order_page.dart';
import 'package:coffix_app/features/payment/presentation/pages/payment_page.dart';
import 'package:coffix_app/features/payment/presentation/pages/payment_successful_page.dart';
import 'package:coffix_app/features/products/presentation/pages/add_product_page.dart';
import 'package:coffix_app/features/products/presentation/pages/customize_product_page.dart';
import 'package:coffix_app/features/products/presentation/pages/products_page.dart';
import 'package:coffix_app/features/profile/presentation/pages/about_page.dart';
import 'package:coffix_app/features/profile/presentation/pages/profile_page.dart';
import 'package:coffix_app/features/stores/presentation/pages/stores_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _authSubscription;

  _GoRouterRefreshStream(Stream<dynamic> authStream) {
    notifyListeners();
    _authSubscription = authStream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: "/",
    refreshListenable: _GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      print('Current state: ${state.uri.path}');
      final currentUser = FirebaseAuth.instance.currentUser;
      final isLoggedIn = currentUser != null;
      final loggingIn = state.matchedLocation.startsWith('/welcome');

      // If the user is not logged in, they must login
      if (!isLoggedIn && state.uri.path != LoginPage.route) {
        return loggingIn ? null : LoginPage.route;
      }

      // If the user is logged in but still on AuthView, send them to
      // the home
      if (loggingIn) return '/';

      // No need to redirect at all
      return null;
    },
    routes: [
      GoRoute(
        path: "/login",
        name: LoginPage.route,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: "/create-account",
        name: CreateAccountPage.route,
        builder: (context, state) => const CreateAccountPage(),
      ),
      // WHEN USER IS LOGGED IN
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LayoutPage(shell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/",
                name: HomePage.route,
                builder: (context, state) => const HomePage(),
              ),
              GoRoute(
                path: "/profile",
                name: ProfilePage.route,
                builder: (context, state) => const ProfilePage(),
              ),
              GoRoute(
                path: "/about",
                name: AboutPage.route,
                builder: (context, state) => const AboutPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/coffix-credit",
                name: CreditPage.route,
                builder: (context, state) => const CreditPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/menu",
                name: MenuPage.route,
                builder: (context, state) => const MenuPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/stores",
                name: StoresPage.route,
                builder: (context, state) => const StoresPage(),
              ),
              GoRoute(
                path: "/products",
                name: ProductsPage.route,
                builder: (context, state) => const ProductsPage(),
              ),
              GoRoute(
                path: "/add-product",
                name: AddProductPage.route,
                builder: (context, state) => const AddProductPage(),
              ),
              GoRoute(
                path: "/customize-product",
                name: CustomizeProductPage.route,
                builder: (context, state) => const CustomizeProductPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/my-order",
                name: OrderPage.route,
                builder: (context, state) => const OrderPage(),
              ),
              GoRoute(
                path: "/payment",
                name: PaymentPage.route,
                builder: (context, state) => const PaymentPage(),
              ),
              GoRoute(
                path: "/payment-successful",
                name: PaymentSuccessfulPage.route,
                builder: (context, state) => const PaymentSuccessfulPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
