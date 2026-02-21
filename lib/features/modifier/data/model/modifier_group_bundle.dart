import 'package:coffix_app/features/modifier/data/model/modifier.dart';
import 'package:coffix_app/features/modifier/data/model/modifier_group.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifier_group_bundle.g.dart';

@JsonSerializable()
/// UI-ready bundle: one modifier group and its effective modifiers (after store overrides).
class ModifierGroupBundle {
  final ModifierGroup group;
  final List<Modifier> modifiers;

  const ModifierGroupBundle({required this.group, required this.modifiers});

  factory ModifierGroupBundle.fromJson(Map<String, dynamic> json) =>
      _$ModifierGroupBundleFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierGroupBundleToJson(this);
}
