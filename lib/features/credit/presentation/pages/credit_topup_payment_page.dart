import 'package:coffix_app/features/credit/presentation/pages/credit_successful_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

class CreditTopupPaymentPage extends StatelessWidget {
  static String route = 'credit_topup_payment_route';

  const CreditTopupPaymentPage({
    super.key,
    required this.paymentSessionUrl,
    required this.amount,
    required this.transactionNumber,
  });

  final String paymentSessionUrl;
  final double amount;
  final String transactionNumber;

  @override
  Widget build(BuildContext context) {
    return CreditTopupPaymentView(
      paymentSessionUrl: paymentSessionUrl,
      amount: amount,
      transactionNumber: transactionNumber,
    );
  }
}

class CreditTopupPaymentView extends StatefulWidget {
  const CreditTopupPaymentView({
    super.key,
    required this.paymentSessionUrl,
    required this.amount,
    required this.transactionNumber,
  });

  final String paymentSessionUrl;
  final double amount;
  final String transactionNumber;

  @override
  State<CreditTopupPaymentView> createState() => _CreditTopupPaymentViewState();
}

class _CreditTopupPaymentViewState extends State<CreditTopupPaymentView> {
  final _settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    applePayAPIEnabled: true,
    userAgent:
        "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('TopUp Coffix Credit', style: theme.textTheme.titleLarge),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.paymentSessionUrl)),
        initialSettings: _settings,
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final url = navigationAction.request.url?.toString() ?? '';
          final uri = Uri.parse(url);
          final isSuccess =
              uri.scheme == 'https' &&
              uri.host == 'www.coffix.co.nz' &&
              (uri.path == '/payment/successful' ||
                  uri.path.contains('/credit') && uri.path.contains('success'));
          if (isSuccess) {
            context.pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.goNamed(
                  CreditSuccessfulPage.route,
                  extra: {
                    'amount': widget.amount,
                    'transactionNumber': widget.transactionNumber,
                  },
                );
              }
            });
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }
}
