// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
  docId: json['docId'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  nickName: json['nickName'] as String?,
  mobile: json['mobile'] as String?,
  birthday: _$JsonConverterFromJson<String, DateTime>(
    json['birthday'],
    const DateTimeConverter().fromJson,
  ),
  suburb: json['suburb'] as String?,
  city: json['city'] as String?,
  preferredStore: json['preferredStore'] as String?,
  createdAt: _$JsonConverterFromJson<String, DateTime>(
    json['createdAt'],
    const DateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
  'docId': instance.docId,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'nickName': instance.nickName,
  'mobile': instance.mobile,
  'birthday': _$JsonConverterToJson<String, DateTime>(
    instance.birthday,
    const DateTimeConverter().toJson,
  ),
  'suburb': instance.suburb,
  'city': instance.city,
  'preferredStore': instance.preferredStore,
  'createdAt': _$JsonConverterToJson<String, DateTime>(
    instance.createdAt,
    const DateTimeConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
