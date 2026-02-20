part of 'store_cubit.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState.initial() = _Initial;
  const factory StoreState.loading() = _Loading;
  const factory StoreState.error({required String message}) = _Error;
  const factory StoreState.loaded({required List<Store> stores}) = _Loaded;
}
