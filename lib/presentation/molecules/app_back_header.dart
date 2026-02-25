import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackHeader extends StatefulWidget {
  final VoidCallback? onBack;
  final String title;
  final bool showLocation;
  final bool showBackButton;

  const AppBackHeader({
    super.key,
    this.onBack,
    required this.title,
    this.showLocation = true,
    this.showBackButton = true,
  });

  @override
  State<AppBackHeader> createState() => _AppBackHeaderState();
}

class _AppBackHeaderState extends State<AppBackHeader> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, bottom: AppSizes.sm),
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
                      if (widget.showBackButton)
                        AppClickable(
                          showSplash: false,
                          onPressed: () {
                            if (widget.onBack != null) {
                              widget.onBack!();
                            } else {
                              context.pop();
                            }
                          },
                          child: Icon(Icons.arrow_back_ios),
                        ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Center(
                      child: Text(
                        widget.title,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    if (widget.showLocation) AppLocation(),
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
