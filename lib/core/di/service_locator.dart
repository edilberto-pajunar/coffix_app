import 'package:coffix_app/data/repositories/auth_repository.dart';
import 'package:coffix_app/features/auth/data/auth_repository_impl.dart';
import 'package:coffix_app/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Initializes all singleton services for the app.
Future<void> setupServiceLocator() async {
  // -- Auth Feature --
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // Auth Cubit
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(authRepository: getIt<AuthRepository>()),
  );
}
