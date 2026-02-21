import 'package:coffix_app/features/products/data/model/product_with_category.dart';

extension ProductExtensions on List<ProductWithCategory> {
  /// Returns a list of products that are available in the given store.
  List<ProductWithCategory> productsByStore(String storeId) {
    return where(
      (product) => product.product.availableToStores?.contains(storeId) ?? false,
    ).toList();
  }
}
