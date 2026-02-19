import 'package:coffix_app/core/flavors/flavor_config.dart';
import 'package:coffix_app/core/routes/app_router.dart';
import 'package:coffix_app/core/theme/app_theme.dart';
import 'package:coffix_app/bootstrap.dart';
import 'package:flutter/material.dart';

void mainCommon({
  required Flavor flavor,
  required String baseUrl,
  required String name,
}) {
  FlavorConfig(flavor: flavor, baseUrl: baseUrl, name: name);

  bootstrap(() => MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: AppTheme.theme,
    );
  }
}
