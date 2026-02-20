import 'package:coffix_app/data/repositories/auth_repository.dart';
import 'package:coffix_app/data/repositories/product_repository.dart';
import 'package:coffix_app/data/repositories/profile_repository.dart';
import 'package:coffix_app/data/repositories/store_repository.dart';
import 'package:coffix_app/features/auth/data/auth_repository_impl.dart';
import 'package:coffix_app/features/auth/logic/auth_cubit.dart';
import 'package:coffix_app/features/auth/logic/otp_cubit.dart';
import 'package:coffix_app/features/order/logic/cart_cubit.dart';
import 'package:coffix_app/features/order/logic/schedule_cubit.dart';
import 'package:coffix_app/features/products/data/product_repository_impl.dart';
import 'package:coffix_app/features/products/logic/modifier_cubit.dart';
import 'package:coffix_app/features/products/logic/product_cubit.dart';
import 'package:coffix_app/features/products/logic/product_modifier_cubit.dart';
import 'package:coffix_app/features/profile/data/profile_repository_impl.dart';
import 'package:coffix_app/features/profile/domain/usecase/update_profile.dart';
import 'package:coffix_app/features/profile/logic/profile_cubit.dart';
import 'package:coffix_app/features/stores/data/store_repository_impl.dart';
import 'package:coffix_app/features/stores/logic/store_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Initializes all singleton services for the app.
Future<void> setupServiceLocator() async {
  // -- Auth Feature --
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  getIt.registerLazySingleton<StoreRepository>(() => StoreRepositoryImpl());

  // Auth Cubit
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(authRepository: getIt<AuthRepository>()),
  );

  // Cart Cubit
  getIt.registerLazySingleton<CartCubit>(() => CartCubit());

  // Schedule Cubit (pickup time for current order)
  getIt.registerLazySingleton<ScheduleCubit>(() => ScheduleCubit());

  // Otp Cubit
  getIt.registerLazySingleton<OtpCubit>(
    () => OtpCubit(authRepository: getIt<AuthRepository>()),
  );

  // Modifier Cubit
  getIt.registerLazySingleton<ModifierCubit>(
    () => ModifierCubit(productRepository: getIt<ProductRepository>()),
  );

  // Product Modifier Cubit
  getIt.registerLazySingleton<ProductModifierCubit>(
    () => ProductModifierCubit(),
  );

  // Update Profile Use Case
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(profileRepository: getIt<ProfileRepository>()),
  );

  // Profile Cubit
  getIt.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(
      profileRepository: getIt<ProfileRepository>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
    ),
  );

  // Product Cubit
  getIt.registerLazySingleton<ProductCubit>(
    () => ProductCubit(productRepository: getIt<ProductRepository>()),
  );

  // Store Cubit
  getIt.registerLazySingleton<StoreCubit>(
    () => StoreCubit(storeRepository: getIt<StoreRepository>()),
  );
}
