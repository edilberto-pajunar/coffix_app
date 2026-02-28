import 'package:coffix_app/core/utils/date_time_converter.dart';
import 'package:coffix_app/features/cart/data/model/cart_item.dart';
import 'package:coffix_app/features/payment/data/model/payment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.g.dart';

@JsonSerializable(explicitToJson: true)
class Cart {
  final String storeId;
  final List<CartItem> items;
  @DateTimeConverter()
  final double duration;
  final PaymentMethod? paymentMethod;

  Cart({
    required this.storeId,
    this.items = const [],
    required this.duration,
    this.paymentMethod,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.lineTotal);
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  Cart copyWith({
    String? storeId,
    List<CartItem>? items,
    double? duration,
    PaymentMethod? paymentMethod,
  }) => Cart(
    storeId: storeId ?? this.storeId,
    items: items ?? this.items,
    duration: duration ?? this.duration,
    paymentMethod: paymentMethod ?? this.paymentMethod,
  );
}
