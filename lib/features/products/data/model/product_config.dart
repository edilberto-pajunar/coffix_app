import 'package:coffix_app/features/modifier/data/model/modifier.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_config.g.dart';

@JsonSerializable()
class ProductConfig {
  final Product? product;
  final List<Modifier>? modifiers;

  ProductConfig({this.product, this.modifiers});

  factory ProductConfig.fromJson(Map<String, dynamic> json) =>
      _$ProductConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ProductConfigToJson(this);
}
