// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  docId: json['docId'] as String?,
  customerId: json['customerId'] as String?,
  storeId: json['storeId'] as String?,
  total: (json['total'] as num?)?.toDouble(),
  createdAt: const DateTimeConverter().fromJson(json['createdAt']),
  scheduledAt: const DateTimeConverter().fromJson(json['scheduledAt']),
  orderNumber: json['orderNumber'] as String?,
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'docId': instance.docId,
  'customerId': instance.customerId,
  'storeId': instance.storeId,
  'total': instance.total,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
  'scheduledAt': const DateTimeConverter().toJson(instance.scheduledAt),
  'orderNumber': instance.orderNumber,
};
