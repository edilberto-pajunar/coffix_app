import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_card.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutPage extends StatelessWidget {
  static String route = 'about_route';
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AboutView();
  }
}

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("About", style: theme.textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSizes.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'General information',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _InfoRow(label: 'App version', value: '1.0.0'),
                  const Divider(height: 1),
                  _InfoRow(label: 'Last login', value: '—'),
                  const Divider(height: 1),
                  _InfoRow(label: 'Customer ID', value: '—'),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
            AppClickable(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                child: Text(
                  'Report an issue / feedback',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.accent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            AppClickable(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                child: Text(
                  'Coffix website',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.accent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
            AppClickable(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                child: Text(
                  'Delete account',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.lightGrey,
            ),
          ),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
