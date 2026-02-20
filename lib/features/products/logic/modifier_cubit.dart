import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/repositories/product_repository.dart';
import 'package:coffix_app/features/products/data/model/modifier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifier_state.dart';
part 'modifier_cubit.freezed.dart';

class ModifierCubit extends Cubit<ModifierState> {
  final ProductRepository _productRepository;
  ModifierCubit({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(ModifierState.initial());

  void getModifiers() async {
    emit(ModifierState.loading());
    try {
      final modifiers = await _productRepository.getModifiers();
      emit(ModifierState.loaded(modifiers: modifiers));
    } catch (e) {
      emit(ModifierState.error(message: e.toString()));
    }
  }
}
