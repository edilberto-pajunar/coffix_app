import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_category.g.dart';

@JsonSerializable()
class ProductCategory {
  final String? docId;
  final String? imageUrl;
  final String? name;
  final String? order;

  ProductCategory({this.docId, this.imageUrl, this.name, this.order});

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}
