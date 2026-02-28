import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/images.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/theme/typography.dart';
import 'package:coffix_app/features/credit/presentation/widgets/info_card.dart';
import 'package:coffix_app/features/credit/presentation/widgets/tier_card.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/molecules/app_back_header.dart';
import 'package:flutter/material.dart';

class CreditPage extends StatelessWidget {
  static String route = 'credit_route';
  const CreditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CreditView();
  }
}

class CreditView extends StatelessWidget {
  const CreditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSizes.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBackHeader(title: "Coffix Credit", showBackButton: false),
              Text(
                'Pay by Coffix Credit and save 10% - 20%',
                style: AppTypography.headlineM.copyWith(color: AppColors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.xxl),
              Text(
                'How it works',
                style: AppTypography.titleM.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: AppSizes.md),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoCard(
                      text: 'Top up your Coffix credit account',
                      image: AppImages.topup,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    InfoCard(
                      text: 'Order in your app',
                      image: AppImages.coffee,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    InfoCard(
                      text: 'Get 10% - 20% discount for any order',
                      image: AppImages.discount,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              Text(
                'Top-up bonus',
                style: AppTypography.titleM.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: AppSizes.md),
              TierCard(amount: 50, percent: '10%'),
              const SizedBox(height: AppSizes.sm),
              TierCard(amount: 250, percent: '15%'),
              const SizedBox(height: AppSizes.sm),
              TierCard(amount: 500, percent: '20%'),
              const SizedBox(height: AppSizes.xl),
              AppButton(onPressed: () {}, label: "Top Up Your Coffix Credit"),
            ],
          ),
        ),
      ),
    );
  }
}
