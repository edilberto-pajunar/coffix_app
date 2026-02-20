import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/di/service_locator.dart';
import 'package:coffix_app/features/order/logic/schedule_cubit.dart';
import 'package:coffix_app/features/payment/presentation/pages/payment_successful_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentWebPage extends StatelessWidget {
  static String route = 'payment_web_route';
  const PaymentWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaymentWebView();
  }
}

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({super.key});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final pickupAt =
          getIt<ScheduleCubit>().state ??
          DateTime.now().add(const Duration(minutes: 15));
      context.goNamed(PaymentSuccessfulPage.route, extra: pickupAt);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment', style: theme.textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSizes.defaultPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: AppSizes.xxxxxl,
                  height: AppSizes.xxxxxl,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),
                Text(
                  'Processing payment…',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Please wait, do not close this page.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
