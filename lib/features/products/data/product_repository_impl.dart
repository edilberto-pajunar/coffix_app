import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffix_app/data/repositories/product_repository.dart';
import 'package:coffix_app/features/products/data/model/modifier.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:coffix_app/features/products/data/model/product_category.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((event) {
      return event.docs.map((doc) => Product.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<List<ProductCategory>> getProductCategories() async {
    final snapshot = await _firestore.collection('productCategories').get();
    return snapshot.docs
        .map((doc) => ProductCategory.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<Modifier>> getModifiers() async {
    final snapshot = await _firestore.collection('modifiers').get();
    return snapshot.docs.map((doc) => Modifier.fromJson(doc.data())).toList();
  }
}
