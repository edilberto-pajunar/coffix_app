import 'package:coffix_app/presentation/molecules/app_back_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
  final _settings = InAppWebViewSettings(javaScriptEnabled: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBackHeader(title: "", showLocation: false),
      body: widget.url.isNotEmpty
          ? InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialSettings: _settings,
            )
          : const SizedBox.shrink(),
    );
  }
}
