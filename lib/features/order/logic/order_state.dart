part of 'order_cubit.dart';

@freezed
abstract class OrderState with _$OrderState {
  const factory OrderState.initial({@Default([]) List<Order> orders}) =
      _Initial;
  const factory OrderState.loading({@Default([]) List<Order> orders}) =
      _Loading;
  const factory OrderState.loaded({@Default([]) List<Order> orders}) = _Loaded;
  const factory OrderState.error({
    @Default([]) List<Order> orders,
    required String message,
  }) = _Error;
  const factory OrderState.emailSent({
    @Default([]) List<Order> orders,
    required String message,
  }) = _EmailSent;
}
