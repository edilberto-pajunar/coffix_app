import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/theme/typography.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PaymentSuccessfulPage extends StatelessWidget {
  static String route = 'payment_successful_route';
  const PaymentSuccessfulPage({super.key, this.pickupAt});

  final DateTime? pickupAt;

  @override
  Widget build(BuildContext context) {
    return PaymentSuccessfulView(pickupAt: pickupAt);
  }
}

class PaymentSuccessfulView extends StatelessWidget {
  const PaymentSuccessfulView({super.key, this.pickupAt});

  final DateTime? pickupAt;

  @override
  Widget build(BuildContext context) {
    final pickupTime =
        pickupAt ?? DateTime.now().add(const Duration(minutes: 15));
    final timeText = DateFormat.jm().format(pickupTime);

    return Scaffold(
      appBar: AppBar(title: Text('Order confirmed'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: AppSizes.defaultPadding,
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.check_circle_rounded,
                size: AppSizes.iconSizeXLarge,
                color: AppColors.success,
              ),
              const SizedBox(height: AppSizes.xxl),
              Text(
                'Payment successful',
                style: AppTypography.headlineXl,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                'Your order will be ready for pickup at',
                style: AppTypography.bodyXS,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xl,
                  vertical: AppSizes.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.md),
                ),
                child: Text(
                  timeText,
                  style: AppTypography.titleM.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              AppButton.primary(
                onPressed: () => context.go('/'),
                label: 'Back to home',
              ),
              const SizedBox(height: AppSizes.lg),
            ],
          ),
        ),
      ),
    );
  }
}
