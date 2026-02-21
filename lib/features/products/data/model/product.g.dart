// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  availableToStores: (json['availableToStores'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  categoryId: json['categoryId'] as String?,
  cost: (json['cost'] as num?)?.toDouble(),
  docId: json['docId'] as String?,
  imageUrl: json['imageUrl'] as String?,
  modifierGroupIds: (json['modifierGroupIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  name: json['name'] as String?,
  order: (json['order'] as num?)?.toDouble(),
  price: (json['price'] as num?)?.toDouble(),
  categoryName: json['categoryName'] as String?,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'availableToStores': instance.availableToStores,
  'categoryId': instance.categoryId,
  'cost': instance.cost,
  'docId': instance.docId,
  'imageUrl': instance.imageUrl,
  'modifierGroupIds': instance.modifierGroupIds,
  'name': instance.name,
  'order': instance.order,
  'price': instance.price,
  'categoryName': instance.categoryName,
};
