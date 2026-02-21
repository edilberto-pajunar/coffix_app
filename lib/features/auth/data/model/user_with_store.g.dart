// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_with_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUserWithStore _$AppUserWithStoreFromJson(Map<String, dynamic> json) =>
    AppUserWithStore(
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      store: json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppUserWithStoreToJson(AppUserWithStore instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'store': instance.store?.toJson(),
    };
