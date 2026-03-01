import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/images.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/di/service_locator.dart';
import 'package:coffix_app/features/auth/logic/auth_cubit.dart';
import 'package:coffix_app/features/menu/presentation/pages/menu_page.dart';
import 'package:coffix_app/features/order/presentation/pages/order_page.dart';
import 'package:coffix_app/features/profile/presentation/pages/profile_page.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_icon.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  static String route = 'home_route';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthCubit>(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<AuthCubit>().state.maybeWhen(
      authenticated: (user) => user.user,
      orElse: () => null,
    );

    return Scaffold(
      // appBar: AppBar(
      // toolbarHeight: 40,
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //       context.pushNamed(ProfilePage.route);
      //     },
      //     icon: Icon(Icons.person, color: AppColors.white),
      //   ),
      // ],
      // ),
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: AppSizes.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    context.pushNamed(ProfilePage.route);
                  },
                  icon: Icon(Icons.person, color: AppColors.white),
                ),
              ),
              AppIcon.withSvgPath(
                AppImages.nameLogo,
                size: AppSizes.iconSizeXLarge,
              ),
              AppLocation(),
              const SizedBox(height: AppSizes.xxxxl),
              Text(
                "Welcome ${user?.firstName ?? user?.nickName ?? ""}",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              AppIcon.withSvgPath(
                AppImages.logo,
                size: AppSizes.iconSizeXXLarge,
              ),
              Spacer(),
              AppButton.primary(
                onPressed: () {
                  context.goNamed(MenuPage.route);
                },
                label: "New Order",
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: AppButton.primary(
                      onPressed: () {
                        context.pushNamed(OrderPage.route);
                      },
                      label: "ReOrder",
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: AppButton.primary(
                      onPressed: () {},
                      disabled: true,
                      label: "My Drafts",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
