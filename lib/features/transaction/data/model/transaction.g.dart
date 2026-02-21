// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  docId: json['docId'] as String?,
  orderNumber: json['orderNumber'] as String?,
  customerId: json['customerId'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  createdAt: const DateTimeConverter().fromJson(json['createdAt']),
  status: $enumDecodeNullable(_$TransactionStatusEnumMap, json['status']),
  paymentMethod: json['paymentMethod'] as String?,
  paymentId: json['paymentId'] as String?,
  paymentTime: const DateTimeConverter().fromJson(json['paymentTime']),
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'orderNumber': instance.orderNumber,
      'customerId': instance.customerId,
      'amount': instance.amount,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'status': _$TransactionStatusEnumMap[instance.status],
      'paymentMethod': instance.paymentMethod,
      'paymentId': instance.paymentId,
      'paymentTime': const DateTimeConverter().toJson(instance.paymentTime),
    };

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.paid: 'paid',
  TransactionStatus.failed: 'failed',
};
