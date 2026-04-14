import 'package:coffix_app/features/payment/data/model/payment.dart';

abstract class PaymentRepository {
  Future<Map<String, dynamic>> createPaymentSession({
    required PaymentRequest request,
  });

  Future<Map<String, dynamic>> topupCredit({required double amount});
}
