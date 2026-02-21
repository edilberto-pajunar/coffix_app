import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_override.g.dart';

@JsonSerializable()
class ProductOverride {
  final List<String> disabledGroupIds;
  final List<String> disabledModifierIds;

  ProductOverride({
    required this.disabledGroupIds,
    required this.disabledModifierIds,
  });

  factory ProductOverride.fromJson(Map<String, dynamic> json) =>
      _$ProductOverrideFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOverrideToJson(this);
}
