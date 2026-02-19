import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/images.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_icon.dart';
import 'package:flutter/material.dart';

class AppLocation extends StatelessWidget {
  const AppLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIcon.withSvgPath(AppImages.location, size: AppSizes.iconSizeMedium),
        Text(
          "Coffix Hamilton",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: AppColors.lightGrey,
          ),
        ),
      ],
    );
  }
}
