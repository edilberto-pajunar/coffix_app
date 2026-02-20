import 'package:coffix_app/features/order/data/model/cart_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.g.dart';

@JsonSerializable(explicitToJson: true)
class Cart {
  final String? storeId;
  final List<CartItem> items;

  Cart({this.storeId, this.items = const []});

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);

  double get total => items.fold(0.0, (sum, item) => sum + item.total);
}
