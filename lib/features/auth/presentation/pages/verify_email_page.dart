import 'package:flutter/material.dart';

class VerifyEmailPage extends StatelessWidget {
  static String route = 'verify_email_route';
  const VerifyEmailPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return VerifyEmailView(email: email);
  }
}

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
