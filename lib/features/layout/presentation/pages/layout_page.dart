import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/images.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum LayoutPageTab {
  home(title: "Home", icon: AppImages.home, selectedIcon: AppImages.home),
  coffixCredit(
    title: "Coffix Credit",
    icon: AppImages.credit,
    selectedIcon: AppImages.credit,
  ),
  menu(title: "Menu", icon: AppImages.menu, selectedIcon: AppImages.menu),
  stores(
    title: "Stores",
    icon: AppImages.location,
    selectedIcon: AppImages.location,
  ),
  order(title: "My Order", icon: AppImages.cart, selectedIcon: AppImages.cart);

  final String title;
  final String icon;
  final String selectedIcon;

  const LayoutPageTab({
    required this.title,
    required this.icon,
    required this.selectedIcon,
  });
}

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return LayoutView(shell: shell);
  }
}

class LayoutView extends StatelessWidget {
  const LayoutView({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    // List of exact routes where the bottom nav bar should show
    const tabRoutes = ["/", "/coffix-credit", "/menu", "/stores", "/my-order"];

    // Show bottom nav only if we are on a tab route
    final showBottomNav = tabRoutes.contains(location);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          // Get the current tab index
          final currentIndex = shell.currentIndex;

          // If we're not on the home tab (index 0), go back to home
          if (currentIndex != 0) {
            shell.goBranch(0);
          }
        }
      },
      child: Scaffold(
        body: shell,
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            bottomAppBarTheme: const BottomAppBarThemeData(
              shadowColor: Colors.transparent,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              enableFeedback: false,
            ),
          ),
          child: showBottomNav
              ? SizedBox(
                  child: BottomNavigationBar(
                    currentIndex: shell.currentIndex,
                    onTap: (index) {
                      shell.goBranch(index, initialLocation: true);
                    },
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    fixedColor: AppColors.primary,
                    selectedFontSize: 12,
                    items: LayoutPageTab.values
                        .map(
                          (tab) => BottomNavigationBarItem(
                            icon: AppIcon.withSvgPath(
                              tab.icon,
                              size: AppSizes.iconSizeLarge,
                              color:
                                  shell.currentIndex ==
                                      LayoutPageTab.values.indexOf(tab)
                                  ? AppColors.primary
                                  : AppColors.lightGrey,
                            ),
                            label: tab.title,
                          ),
                        )
                        .toList(),
                  ),
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
