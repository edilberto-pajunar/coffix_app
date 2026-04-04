// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Referral _$ReferralFromJson(Map<String, dynamic> json) => Referral(
  docId: json['docId'] as String?,
  referralTime: const DateTimeConverter().fromJson(json['referralTime']),
  referrer: json['referrer'] as String?,
  referee: json['referee'] as String?,
);

Map<String, dynamic> _$ReferralToJson(Referral instance) => <String, dynamic>{
  'docId': instance.docId,
  'referralTime': const DateTimeConverter().toJson(instance.referralTime),
  'referrer': instance.referrer,
  'referee': instance.referee,
};
