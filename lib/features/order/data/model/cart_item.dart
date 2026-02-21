import 'package:coffix_app/features/modifier/data/model/modifier.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.g.dart';

// This will be used for showing display only in the
// my cart screen
@JsonSerializable()
class CartItem {
  final Product product;
  final double price;
  final int quantity;
  final double total;
  final String storeId;
  final List<Modifier> modifiers;

  CartItem({
    required this.product,
    this.price = 0.0,
    this.quantity = 1,
    this.total = 0.0,
    required this.storeId,
    this.modifiers = const [],
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
