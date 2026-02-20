import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/repositories/product_repository.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:coffix_app/features/products/data/model/product_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_state.dart';
part 'product_cubit.freezed.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription<List<Product>>? _productsSubscription;

  ProductCubit({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(ProductState.initial());

  Future<void> getProducts() async {
    emit(ProductState.loading());
    try {
      final productCategories = await _productRepository.getProductCategories();
      _productsSubscription?.cancel();
      _productsSubscription = _productRepository.getProducts().listen(
        (products) => emit(
          ProductState.loaded(
            products: products,
            productCategories: productCategories,
          ),
        ),
        onError: (e) => emit(ProductState.error(message: e.toString())),
      );
    } catch (e) {
      emit(ProductState.error(message: e.toString()));
    }
  }

  
}
