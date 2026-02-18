import 'package:coffix_app/features/auth/presentation/pages/create_account_page.dart';
import 'package:coffix_app/features/auth/presentation/pages/login_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        name: LoginPage.route,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: "/create-account",
        name: CreateAccountPage.route,
        builder: (context, state) => const CreateAccountPage(),
      ),
    ],
  );
}
