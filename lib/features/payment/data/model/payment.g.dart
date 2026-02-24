// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      storeId: json['storeId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => PaymentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'items': instance.items,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
    };

PaymentItem _$PaymentItemFromJson(Map<String, dynamic> json) => PaymentItem(
  productId: json['productId'] as String,
  quantity: (json['quantity'] as num).toInt(),
  selectedModifiers: Map<String, String>.from(json['selectedModifiers'] as Map),
);

Map<String, dynamic> _$PaymentItemToJson(PaymentItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'selectedModifiers': instance.selectedModifiers,
    };
