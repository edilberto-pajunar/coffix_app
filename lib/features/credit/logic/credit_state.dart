part of 'credit_cubit.dart';

@freezed
class CreditState with _$CreditState {
  const factory CreditState.initial() = _Initial;
  const factory CreditState.loading() = _Loading;
  const factory CreditState.loaded({required String paymentSessionUrl}) =
      _Loaded;
  const factory CreditState.error({required String message}) = _Error;
}
