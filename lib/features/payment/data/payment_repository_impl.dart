import 'dart:convert';

import 'package:coffix_app/core/api/endpoints.dart';
import 'package:coffix_app/data/repositories/payment_repository.dart';
import 'package:coffix_app/features/payment/data/model/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class PaymentRepositoryImpl implements PaymentRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<String> createPaymentSession({required PaymentRequest request}) async {
    final token = await _auth.currentUser?.getIdToken();
    if (token == null) throw Exception('No token found');

    final response = await http.post(
      Uri.parse(
        '${ApiEndpoints.baseUrl}/coffix-app-dev/us-central1/v1/payment/session',
      ),
      body: jsonEncode(request.toJson()),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>?;
    final url = data?["data"]['paymentSessionUrl'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception(
        'No payment URL in response (${response.statusCode}): ${response.body}',
      );
    }
    return url;
  }
}
