// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductConfig _$ProductConfigFromJson(Map<String, dynamic> json) =>
    ProductConfig(
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      modifiers: (json['modifiers'] as List<dynamic>?)
          ?.map((e) => Modifier.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductConfigToJson(ProductConfig instance) =>
    <String, dynamic>{
      'product': instance.product,
      'modifiers': instance.modifiers,
    };
