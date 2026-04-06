// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coupon _$CouponFromJson(Map<String, dynamic> json) => Coupon(
  docId: json['docId'] as String?,
  code: json['code'] as String?,
  type: json['type'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  expiryDate: const DateTimeConverter().fromJson(json['expiryDate']),
  storeId: json['storeId'] as String?,
  notes: json['notes'] as String?,
  userIds: (json['userIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  usageLimit: (json['usageLimit'] as num?)?.toInt(),
  usageCount: (json['usageCount'] as num?)?.toInt(),
  source: json['source'] as String?,
  referralId: json['referralId'] as String?,
  isUsed: json['isUsed'] as bool?,
  createdAt: const DateTimeConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
  'docId': instance.docId,
  'code': instance.code,
  'type': instance.type,
  'amount': instance.amount,
  'expiryDate': const DateTimeConverter().toJson(instance.expiryDate),
  'storeId': instance.storeId,
  'notes': instance.notes,
  'userIds': instance.userIds,
  'usageLimit': instance.usageLimit,
  'usageCount': instance.usageCount,
  'source': instance.source,
  'referralId': instance.referralId,
  'isUsed': instance.isUsed,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
};
