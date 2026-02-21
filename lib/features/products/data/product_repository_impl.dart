import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffix_app/data/repositories/product_repository.dart';
import 'package:coffix_app/features/products/data/model/modifier.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:coffix_app/features/products/data/model/product_category.dart';
import 'package:coffix_app/features/products/data/model/product_with_category.dart';
import 'package:rxdart/rxdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((event) {
      return event.docs.map((doc) => Product.fromJson(doc.data())).toList();
    });
  }

  @override
  Stream<List<ProductCategory>> getProductCategories() {
    return _firestore.collection('productCategories').snapshots().map((event) {
      return event.docs
          .map((doc) => ProductCategory.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  Future<List<Modifier>> getModifiers() async {
    final snapshot = await _firestore.collection('modifiers').get();
    return snapshot.docs.map((doc) => Modifier.fromJson(doc.data())).toList();
  }

  @override
  Stream<List<ProductWithCategory>> getProductsWithCategories() {
    return Rx.combineLatest2(getProducts(), getProductCategories(), (
      List<Product> products,
      List<ProductCategory> categories,
    ) {
      final categoryMap = {for (var c in categories) c.docId: c};

      return products.map((product) {
        final category = categoryMap[product.categoryId];
        return ProductWithCategory(product: product, category: category!);
      }).toList();
    });
  }
}
