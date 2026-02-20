// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Modifier _$ModifierFromJson(Map<String, dynamic> json) => Modifier(
  docId: json['docId'] as String?,
  groupId: json['groupId'] as String?,
  isDefault: json['isDefault'] as bool?,
  label: json['label'] as String?,
  priceDelta: (json['priceDelta'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ModifierToJson(Modifier instance) => <String, dynamic>{
  'docId': instance.docId,
  'groupId': instance.groupId,
  'isDefault': instance.isDefault,
  'label': instance.label,
  'priceDelta': instance.priceDelta,
};
