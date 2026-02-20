import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  final List<String>? availableStores;
  final String? categoryId;
  final double? cost;
  final String? docId;
  final String? imageUrl;
  final List<String>? modifierGroupCodes;
  final String? name;
  final double? order;
  final double? price;

  Product({
    this.availableStores,
    this.categoryId,
    this.cost,
    this.docId,
    this.imageUrl,
    this.modifierGroupCodes,
    this.name,
    this.order,
    this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
