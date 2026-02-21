// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_group_bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifierGroupBundle _$ModifierGroupBundleFromJson(Map<String, dynamic> json) =>
    ModifierGroupBundle(
      group: ModifierGroup.fromJson(json['group'] as Map<String, dynamic>),
      modifiers: (json['modifiers'] as List<dynamic>)
          .map((e) => Modifier.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModifierGroupBundleToJson(
  ModifierGroupBundle instance,
) => <String, dynamic>{
  'group': instance.group,
  'modifiers': instance.modifiers,
};
