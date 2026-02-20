// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) =>
    ProductCategory(
      docId: json['docId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      name: json['name'] as String?,
      order: json['order'] as String?,
    );

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'order': instance.order,
    };
