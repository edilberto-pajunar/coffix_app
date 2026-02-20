part of 'product_modifier_cubit.dart';

@freezed
abstract class ProductModifierState with _$ProductModifierState {
  const factory ProductModifierState({
    @Default([]) List<Modifier> modifiers,
    @Default(0.0) double totalPrice,
  }) = _ProductModifierState;
}
