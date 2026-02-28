import 'package:bloc/bloc.dart';
import 'package:coffix_app/features/cart/data/model/cart.dart';
import 'package:coffix_app/features/cart/data/model/cart_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_cubit.freezed.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  Map<String, String>? selectedByGroup;
  CartCubit() : super(CartState());

  void addProduct({required CartItem newItem}) {
    final Cart? currentCart = state.cart;

    // 1. if no cart yet -> create cart
    if (currentCart == null) {
      emit(
        state.copyWith(
          cart: Cart(
            storeId: newItem.storeId,
            items: [newItem],
            scheduledAt: DateTime.now(),
          ),
        ),
      );
      return;
    }

    // 2. cart is store-scopred -> block or clear when store changes
    if (currentCart.storeId != newItem.storeId) {
      throw Exception('Cannot add product to different store cart');
    }

    // 3. merge identical config by cartItemId
    final index = currentCart.items.indexWhere((item) => item.id == newItem.id);
    if (index == -1) {
      emit(
        state.copyWith(
          cart: currentCart.copyWith(items: [...currentCart.items, newItem]),
        ),
      );
      return;
    }

    final CartItem existing = currentCart.items[index];
    final int newQuantity = existing.quantity + newItem.quantity;

    final updated = existing.copyWith(
      quantity: newQuantity,
      lineTotal: existing.unitTotal * newQuantity,
    );

    final updatedItems = [...currentCart.items]..[index] = updated;

    emit(state.copyWith(cart: currentCart.copyWith(items: updatedItems)));
  }

  void updateProduct({
    required String cartItemId,
    required CartItem updatedItem,
  }) {
    final Cart? currentCart = state.cart;
    if (currentCart == null) return;
    final index = currentCart.items.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return;
    final updatedItems = [...currentCart.items]..[index] = updatedItem;
    emit(state.copyWith(
      cart: currentCart.copyWith(items: updatedItems),
    ));
  }

  void removeProduct({required String cartItemId}) {
    final Cart? currentCart = state.cart;
    if (currentCart == null) return;
    final newItems = currentCart.items
        .where((item) => item.id != cartItemId)
        .toList();
    if (newItems.isEmpty) {
      emit(state.copyWith(cart: null));
    } else {
      emit(state.copyWith(cart: currentCart.copyWith(items: newItems)));
    }
  }

  void resetCart() {
    emit(state.copyWith(cart: null));
  }

  void pickTime(DateTime dateTime) {
    emit(state.copyWith(cart: state.cart?.copyWith(scheduledAt: dateTime)));
  }
}
