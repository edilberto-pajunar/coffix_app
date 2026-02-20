import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/payment/presentation/pages/payment_web_page.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_card.dart';
import 'package:coffix_app/presentation/atoms/app_clickable.dart';
import 'package:coffix_app/presentation/atoms/app_icon.dart';
import 'package:coffix_app/presentation/atoms/app_location.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends StatelessWidget {
  static String route = 'payment_route';
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaymentView();
  }
}

class _PaymentOption {
  const _PaymentOption({
    required this.id,
    required this.label,
    required this.icon,
  });
  final String id;
  final String label;
  final IconData icon;
}

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  static const _options = [
    _PaymentOption(
      id: 'card',
      label: 'Credit / Debit Card',
      icon: Icons.credit_card_rounded,
    ),
    _PaymentOption(
      id: 'coffix_credit',
      label: 'Coffix Credit',
      icon: Icons.account_balance_wallet_rounded,
    ),
    _PaymentOption(id: 'apple_pay', label: 'Apple Pay', icon: Icons.apple),
    _PaymentOption(
      id: 'google_pay',
      label: 'Google Pay',
      icon: Icons.g_mobiledata_rounded,
    ),
  ];

  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Payment", style: theme.textTheme.titleLarge)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSizes.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppLocation(),
                  const SizedBox(height: AppSizes.xxl),
                  Text(
                    'Select payment method',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSizes.md),
                  ..._options.map((option) {
                    final isSelected = _selectedId == option.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.sm),
                      child: AppClickable(
                        onPressed: () {
                          setState(() {
                            _selectedId = _selectedId == option.id
                                ? null
                                : option.id;
                          });
                        },
                        borderRadius: BorderRadius.circular(AppSizes.md),
                        child: AppCard(
                          borderColor: isSelected ? AppColors.primary : null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.lg,
                            vertical: AppSizes.md,
                          ),
                          child: Row(
                            children: [
                              AppIcon.withIconData(
                                option.icon,
                                size: AppSizes.iconSizeMedium,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.black,
                              ),
                              const SizedBox(width: AppSizes.md),
                              Expanded(
                                child: Text(
                                  option.label,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                              if (isSelected)
                                AppIcon.withIconData(
                                  Icons.check_circle_rounded,
                                  size: AppSizes.iconSizeSmall,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          if (_selectedId != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.xxl,
                  AppSizes.md,
                  AppSizes.xxl,
                  AppSizes.xxl,
                ),
                child: AppButton.primary(
                  onPressed: () {
                    context.pushNamed(PaymentWebPage.route);
                  },
                  label: 'Pay',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
