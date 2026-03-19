import 'package:coffix_app/core/di/service_locator.dart';
import 'package:coffix_app/presentation/molecules/app_back_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpecialUrlPage extends StatelessWidget {
  static String route = 'special_url_route';
  const SpecialUrlPage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return SpecialUrlView(url: url);
  }
}

class SpecialUrlView extends StatefulWidget {
  const SpecialUrlView({super.key, required this.url});

  final String url;

  @override
  State<SpecialUrlView> createState() => _SpecialUrlViewState();
}

class _SpecialUrlViewState extends State<SpecialUrlView> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      );
    if (widget.url.isNotEmpty) {
      _webViewController.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBackHeader(title: 'Special Url'),
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
