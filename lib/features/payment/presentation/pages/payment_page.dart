import 'package:coffix_app/core/di/service_locator.dart';
import 'package:coffix_app/features/cart/logic/cart_cubit.dart';
import 'package:coffix_app/features/payment/data/model/payment.dart';
import 'package:coffix_app/features/payment/logic/payment_cubit.dart';
import 'package:coffix_app/features/payment/presentation/pages/payment_successful_page.dart';
import 'package:coffix_app/presentation/atoms/app_loading.dart';
import 'package:coffix_app/presentation/organisms/app_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatelessWidget {
  static String route = 'payment_route';
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CartCubit>()),
        BlocProvider.value(value: getIt<PaymentCubit>()),
      ],
      child: const PaymentView(),
    );
  }
}

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late WebViewController _webViewController;

  @override
  initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            print("Navigating to ${request.url}");
            final uri = Uri.parse(request.url);
            // Use path match, ignore query params
            final isSuccess =
                uri.scheme == 'https' &&
                uri.host == 'www.coffix.co.nz' &&
                uri.path == '/payment/successful';
            if (isSuccess) {
              // IMPORTANT: prevent first
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(PaymentSuccessfulPage.route);
                context.read<CartCubit>().resetCart();
              });
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );
    WidgetsBinding.instance.addPostFrameCallback((_) => initPayment());
  }

  void initPayment() {
    final cart = context.read<CartCubit>().state.cart;
    if (cart == null) return;
    context.read<PaymentCubit>().createPayment(
      request: PaymentRequest(
        storeId: cart.storeId,
        items: cart.items
            .map(
              (item) => PaymentItem(
                productId: item.productId,
                quantity: item.quantity,
                selectedModifiers: item.selectedByGroup,
              ),
            )
            .toList(),
        scheduledAt: cart.scheduledAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Payment", style: theme.textTheme.titleLarge)),
      body: BlocListener<PaymentCubit, PaymentState>(
        listenWhen: (prev, curr) =>
            curr.mapOrNull(loaded: (_) => true) ?? false,
        listener: (context, state) {
          state.maybeWhen(
            loaded: (paymentUrl) =>
                _webViewController.loadRequest(Uri.parse(paymentUrl)),
            orElse: () {},
          );
        },
        child: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => AppLoading(),
              loaded: (_) => WebViewWidget(controller: _webViewController),
              error: (message) =>
                  AppError(title: "Failed to load payment", subtitle: message),
            );
          },
        ),
      ),
    );
  }
}
