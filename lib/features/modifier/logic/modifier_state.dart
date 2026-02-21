part of 'modifier_cubit.dart';

@freezed
class ModifierState with _$ModifierState {
  const factory ModifierState.initial() = _Initial;
  const factory ModifierState.loading() = _Loading;
  const factory ModifierState.loaded({
    required List<ModifierGroupBundle> modifiersGroups,
  }) = _Loaded;
  const factory ModifierState.error({required String message}) = _Error;
}
