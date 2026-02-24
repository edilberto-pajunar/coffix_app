import 'package:coffix_app/features/payment/data/model/payment.dart';

abstract class PaymentRepository {
  Future<String> createPaymentSession({required PaymentRequest request});
}
