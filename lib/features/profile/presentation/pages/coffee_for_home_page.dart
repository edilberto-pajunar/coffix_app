import 'package:coffix_app/presentation/molecules/app_back_header.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CoffeeForHomePage extends StatelessWidget {
  static String route = 'coffee_for_home_route';
  const CoffeeForHomePage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CoffeeForHomeView(url: url);
  }
}

class CoffeeForHomeView extends StatefulWidget {
  const CoffeeForHomeView({super.key, required this.url});

  final String url;

  @override
  State<CoffeeForHomeView> createState() => _CoffeeForHomeViewState();
}

class _CoffeeForHomeViewState extends State<CoffeeForHomeView> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate());
    if (widget.url.isNotEmpty) {
      _webViewController.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBackHeader(title: 'Coffee For Home'),
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
