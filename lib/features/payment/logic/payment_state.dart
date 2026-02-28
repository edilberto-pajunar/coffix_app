part of 'payment_cubit.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.initial() = _Initial;
  const factory PaymentState.loading() = _Loading;
  // Payment URL was created since they payment method is card
  const factory PaymentState.loaded({required String paymentUrl}) = _Loaded;

  // Payment was successful and throws Order
  const factory PaymentState.success({required Order order}) = _Success;
  const factory PaymentState.error({required String message}) = _Error;
}
