// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifierGroup _$ModifierGroupFromJson(Map<String, dynamic> json) =>
    ModifierGroup(
      docId: json['docId'] as String?,
      modifierIds:
          (json['modifierIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      name: json['name'] as String?,
      required: json['required'] as bool?,
      selectionType: json['selectionType'] as String?,
    );

Map<String, dynamic> _$ModifierGroupToJson(ModifierGroup instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'modifierIds': instance.modifierIds,
      'name': instance.name,
      'required': instance.required,
      'selectionType': instance.selectionType,
    };
