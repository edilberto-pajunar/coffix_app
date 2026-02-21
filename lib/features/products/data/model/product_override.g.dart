// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_override.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOverride _$ProductOverrideFromJson(Map<String, dynamic> json) =>
    ProductOverride(
      disabledGroupIds: (json['disabledGroupIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      disabledModifierIds: (json['disabledModifierIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProductOverrideToJson(ProductOverride instance) =>
    <String, dynamic>{
      'disabledGroupIds': instance.disabledGroupIds,
      'disabledModifierIds': instance.disabledModifierIds,
    };
