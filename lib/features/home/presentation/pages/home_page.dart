import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/images.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/profile/presentation/pages/profile_page.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_icon.dart';
import 'package:coffix_app/presentation/atoms/app_icon_button.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        toolbarHeight: 40,
        actions: [
          AppIconButton.withIconData(
            Icons.person,
            onPressed: () {
              context.pushNamed(ProfilePage.route);
            },
            borderColor: Colors.transparent,
          ),
        ],
      ),
      backgroundColor: AppColors.black,
      body: Padding(
        padding: AppSizes.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppIcon.withSvgPath(
                        AppImages.nameLogo,
                        size: AppSizes.iconSizeXLarge,
                      ),
                      AppLocation(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xxxxl),
            Text(
              "Welcome Amine!",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            AppIcon.withSvgPath(AppImages.logo, size: AppSizes.iconSizeXXLarge),
            Spacer(),
            AppButton.primary(onPressed: () {}, label: "New Order"),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: AppButton.primary(onPressed: () {}, label: "ReOrder"),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: AppButton.primary(
                    onPressed: () {},
                    label: "My Drafts",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
