import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/images.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/theme/typography.dart';
import 'package:coffix_app/presentation/atoms/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
   

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: AppSizes.iconSizeXXXLarge),
          SvgPicture.asset(AppImages.nameLogo, width: 124.0, height: 64.0),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Coffix App",
                  textAlign: TextAlign.center,
                  style: AppTypography.titleXL.copyWith(color: AppColors.white),
                ),
                AppIcon.withSvgPath(
                  AppImages.logo,
                  size: AppSizes.iconSizeXXLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
