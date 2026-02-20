// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
  product: Product.fromJson(json['product'] as Map<String, dynamic>),
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  total: (json['total'] as num?)?.toDouble() ?? 0.0,
  storeId: json['storeId'] as String,
  modifiers:
      (json['modifiers'] as List<dynamic>?)
          ?.map((e) => Modifier.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'product': instance.product,
  'price': instance.price,
  'quantity': instance.quantity,
  'total': instance.total,
  'storeId': instance.storeId,
  'modifiers': instance.modifiers,
};
