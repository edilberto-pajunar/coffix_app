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
  status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']),
  paymentStatus: $enumDecodeNullable(
    _$PaymentStatusEnumMap,
    json['paymentStatus'],
  ),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'docId': instance.docId,
  'customerId': instance.customerId,
  'storeId': instance.storeId,
  'total': instance.total,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
  'scheduledAt': const DateTimeConverter().toJson(instance.scheduledAt),
  'orderNumber': instance.orderNumber,
  'status': _$OrderStatusEnumMap[instance.status],
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus],
};

const _$OrderStatusEnumMap = {
  OrderStatus.draft: 'draft',
  OrderStatus.pendingPayment: 'pending_payment',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.paid: 'paid',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.pending: 'pending',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.unpaid: 'unpaid',
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};
