part of 'payment_cubit.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.initial() = _Initial;
  const factory PaymentState.loading() = _Loading;
  const factory PaymentState.loaded({required String paymentUrl}) = _Loaded;
  const factory PaymentState.error({required String message}) = _Error;
}
