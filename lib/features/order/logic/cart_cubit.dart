import 'package:bloc/bloc.dart';
import 'package:coffix_app/features/order/data/model/cart.dart';
import 'package:coffix_app/features/order/data/model/cart_item.dart';
import 'package:coffix_app/features/products/data/model/modifier.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_cubit.freezed.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState());

  static bool _sameProductAndModifiers(CartItem item, Product product, List<Modifier> modifiers) {
    if (item.product.docId != product.docId) return false;
    final a = item.modifiers.map((m) => m.docId).toSet();
    final b = modifiers.map((m) => m.docId).toSet();
    return a.length == b.length && a.containsAll(b);
  }

  void addProduct({
    required Product product,
    required int quantity,
    required String storeId,
    required double total,
    List<Modifier> modifiers = const [],
  }) {
    final currentItems = state.cart?.items ?? [];
    final matchIndex = currentItems.indexWhere((item) => _sameProductAndModifiers(item, product, modifiers));
    final List<CartItem> newItems;
    if (matchIndex >= 0) {
      final existing = currentItems[matchIndex];
      final merged = CartItem(
        product: existing.product,
        quantity: existing.quantity + quantity,
        storeId: existing.storeId,
        modifiers: existing.modifiers,
        total: existing.total + total,
      );
      newItems = [...currentItems]..[matchIndex] = merged;
    } else {
      newItems = [
        ...currentItems,
        CartItem(product: product, quantity: quantity, storeId: storeId, modifiers: modifiers, total: total),
      ];
    }
    final cart = Cart(storeId: state.cart?.storeId, items: newItems);
    emit(CartState(cart: cart));
  }

  void removeProduct({required String productId}) {
    final currentCart = state.cart;
    if (currentCart == null) return;
    final newItems = currentCart.items
        .where((item) => item.product.docId != productId)
        .toList();
    emit(
      CartState(
        cart: Cart(storeId: currentCart.storeId, items: newItems),
      ),
    );
  }
}
