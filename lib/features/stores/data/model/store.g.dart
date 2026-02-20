// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
  address: json['address'] as String?,
  disable: json['disable'] as bool?,
  docId: json['docId'] as String,
  gstNumber: json['gstNumber'] as String?,
  imageUrl: json['imageUrl'] as String?,
  invoiceText: json['invoiceText'] as String?,
  location: json['location'] as String?,
  name: json['name'] as String?,
  openingHours: json['openingHours'] as String?,
  storeCode: json['storeCode'] as String?,
);

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
  'address': instance.address,
  'disable': instance.disable,
  'docId': instance.docId,
  'gstNumber': instance.gstNumber,
  'imageUrl': instance.imageUrl,
  'invoiceText': instance.invoiceText,
  'location': instance.location,
  'name': instance.name,
  'openingHours': instance.openingHours,
  'storeCode': instance.storeCode,
};
