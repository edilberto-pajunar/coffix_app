import 'package:coffix_app/data/repositories/app_repository.dart';
import 'package:coffix_app/data/repositories/auth_repository.dart';
import 'package:coffix_app/data/repositories/modifier_repository.dart';
import 'package:coffix_app/data/repositories/product_repository.dart';
import 'package:coffix_app/data/repositories/profile_repository.dart';
import 'package:coffix_app/data/repositories/store_repository.dart';
import 'package:coffix_app/data/repositories/transaction_repository.dart';
import 'package:coffix_app/features/app/data/app_repository_impl.dart';
import 'package:coffix_app/features/app/logic/app_cubit.dart';
import 'package:coffix_app/features/auth/data/auth_repository_impl.dart';
import 'package:coffix_app/features/auth/logic/auth_cubit.dart';
import 'package:coffix_app/features/auth/logic/otp_cubit.dart';
import 'package:coffix_app/features/modifier/data/modifier_repository_impl.dart';
import 'package:coffix_app/features/cart/logic/cart_cubit.dart';
import 'package:coffix_app/features/order/logic/schedule_cubit.dart';
import 'package:coffix_app/features/products/data/product_repository_impl.dart';
import 'package:coffix_app/features/modifier/logic/modifier_cubit.dart';
import 'package:coffix_app/features/products/logic/product_cubit.dart';
import 'package:coffix_app/features/products/logic/product_modifier_cubit.dart';
import 'package:coffix_app/features/profile/data/profile_repository_impl.dart';
import 'package:coffix_app/features/profile/domain/usecase/update_profile.dart';
import 'package:coffix_app/features/profile/logic/profile_cubit.dart';
import 'package:coffix_app/features/stores/data/store_repository_impl.dart';
import 'package:coffix_app/features/stores/logic/store_cubit.dart';
import 'package:coffix_app/features/transaction/logic/transaction_cubit.dart';
import 'package:coffix_app/features/transaction/transaction_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Initializes all singleton services for the app.
Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<AppRepository>(() => AppRepositoryImpl());
  getIt.registerLazySingleton<StoreRepository>(
    () => StoreRepositoryImpl(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ModifierRepository>(
    () => ModifierRepositoryImpl(storeRepository: getIt<StoreRepository>()),
  );
  // -- Auth Feature --
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(storeRepository: getIt<StoreRepository>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(),
  );
  // App Cubit
  getIt.registerLazySingleton<AppCubit>(
    () => AppCubit(appRepository: getIt<AppRepository>()),
  );
  // Auth Cubit
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      authRepository: getIt<AuthRepository>(),
      storeRepository: getIt<StoreRepository>(),
    ),
  );

  // Cart Cubit
  getIt.registerLazySingleton<CartCubit>(() => CartCubit());

  // Modifier Cubit
  getIt.registerLazySingleton<ModifierCubit>(
    () => ModifierCubit(modifierRepository: getIt<ModifierRepository>()),
  );

  // Otp Cubit
  getIt.registerLazySingleton<OtpCubit>(
    () => OtpCubit(authRepository: getIt<AuthRepository>()),
  );

  // Product Modifier Cubit
  getIt.registerLazySingleton<ProductModifierCubit>(
    () => ProductModifierCubit(),
  );
  // Schedule Cubit (pickup time for current order)
  getIt.registerLazySingleton<ScheduleCubit>(() => ScheduleCubit());
  // Transaction Cubit
  getIt.registerLazySingleton<TransactionCubit>(
    () =>
        TransactionCubit(transactionRepository: getIt<TransactionRepository>()),
  );

  // Update Profile Use Case
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(profileRepository: getIt<ProfileRepository>()),
  );

  // Profile Cubit
  getIt.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(updateProfileUseCase: getIt<UpdateProfileUseCase>()),
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
