import 'package:coffix_app/core/constants/images.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AppBackHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final String title;
  final bool showLocation;

  const AppBackHeader({
    super.key,
    this.onBack,
    required this.title,
    this.showLocation = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: AppSizes.md),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.sm,
              horizontal: AppSizes.xs,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Back Button (Left aligned)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppClickable(
                        showSplash: false,
                        onPressed: () {
                          if (onBack != null) {
                            onBack!();
                          } else {
                            context.pop();
                          }
                        },
                        child: SvgPicture.asset(
                          AppImages.back,
                          width: AppSizes.iconSizeSmall,
                          height: AppSizes.iconSizeSmall,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Center(
                      child: Text(title, style: theme.textTheme.titleLarge),
                    ),
                    if (showLocation) AppLocation(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
