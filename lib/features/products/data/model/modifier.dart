import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifier.g.dart';

@JsonSerializable()
class Modifier {
  final String? docId;
  final String? groupId;
  final bool? isDefault;
  final String? label;
  final double? priceDelta;

  Modifier({
    this.docId,
    this.groupId,
    this.isDefault,
    this.label,
    this.priceDelta,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) =>
      _$ModifierFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierToJson(this);
}
