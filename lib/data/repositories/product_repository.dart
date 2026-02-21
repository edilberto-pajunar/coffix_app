import 'package:coffix_app/features/products/data/model/modifier.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:coffix_app/features/products/data/model/product_category.dart';
import 'package:coffix_app/features/products/data/model/product_with_category.dart';

abstract class ProductRepository {
  Stream<List<Product>> getProducts();
  Stream<List<ProductCategory>> getProductCategories();
  Future<List<Modifier>> getModifiers();
  Stream<List<ProductWithCategory>> getProductsWithCategories();
}
