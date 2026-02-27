import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/images.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/theme/typography.dart';
import 'package:coffix_app/features/home/presentation/pages/home_page.dart';
import 'package:coffix_app/presentation/atoms/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class WrapperPage extends StatelessWidget {
  static String route = 'wrapper_route';
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WrapperView();
  }
}

class WrapperView extends StatefulWidget {
  const WrapperView({super.key});

  @override
  State<WrapperView> createState() => _WrapperViewState();
}

class _WrapperViewState extends State<WrapperView> {
  @override
  void initState() {
    super.initState();
    initWrapper();
  }

  void initWrapper() async {
    Future.delayed(const Duration(seconds: 2), () {
      context.goNamed(HomePage.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: AppIcon.withSvgPath(AppImages.nameLogo, size: 180),
      ),
      backgroundColor: AppColors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Coffix App",
            textAlign: TextAlign.center,
            style: AppTypography.titleXL.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: AppSizes.xl),
          SvgPicture.asset(AppImages.logo, width: 256, height: 256),
        ],
      ),
    );
  }
}
