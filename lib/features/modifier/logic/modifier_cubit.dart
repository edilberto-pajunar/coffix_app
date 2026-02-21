import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/repositories/modifier_repository.dart';
import 'package:coffix_app/features/modifier/data/model/modifier_group_bundle.dart';
import 'package:coffix_app/features/products/data/model/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifier_state.dart';
part 'modifier_cubit.freezed.dart';

class ModifierCubit extends Cubit<ModifierState> {
  final ModifierRepository _modifierRepository;
  ModifierCubit({required ModifierRepository modifierRepository})
    : _modifierRepository = modifierRepository,
      super(ModifierState.initial());

  void getModifiers({required Product product, required String storeId}) async {
    emit(ModifierState.loading());
    try {
      final modifiersGroups = await _modifierRepository.getCustomizationBundles(
        product: product,
        storeId: storeId,
      );
      emit(ModifierState.loaded(modifiersGroups: modifiersGroups));
    } catch (e) {
      emit(ModifierState.error(message: e.toString()));
    }
  }
}
