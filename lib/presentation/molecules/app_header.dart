import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showLocation;

  const AppHeader({super.key, required this.title, this.showLocation = true});

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
            child: Column(
              children: [
                Center(child: Text(title, style: theme.textTheme.titleLarge)),
                if (showLocation) AppLocation(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
