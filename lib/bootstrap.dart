import 'dart:async';

import 'package:coffix_app/core/di/service_locator.dart';
import 'package:coffix_app/core/flavors/flavor_config.dart';
import 'package:coffix_app/firebase_options_dev.dart' as devConfig;
import 'package:coffix_app/firebase_options_prod.dart' as prodConfig;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(Widget Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (FlavorConfig.isDev()) {
    debugPrint('Dev flavor');
    await dotenv.load(fileName: '.env.dev');
    await Firebase.initializeApp(
      options: devConfig.DefaultFirebaseOptions.currentPlatform,
    );
  } else if (FlavorConfig.isProd()) {
    debugPrint('Prod flavor');
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: prodConfig.DefaultFirebaseOptions.currentPlatform,
    );
  }

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  await setupServiceLocator();

  runApp(builder());
}
