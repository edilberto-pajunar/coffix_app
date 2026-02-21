part of 'transaction_cubit.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;
  const factory TransactionState.loading() = _Loading;
  const factory TransactionState.loaded({
    required List<Transaction> transactions,
  }) = _Loaded;
  const factory TransactionState.error({required String message}) = _Error;
}
