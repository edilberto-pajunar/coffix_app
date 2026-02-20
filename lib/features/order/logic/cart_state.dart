part of 'cart_cubit.dart';

@freezed
abstract class CartState with _$CartState {
  const factory CartState({@Default(null) Cart? cart}) = _CartState;

  const CartState._();
}
