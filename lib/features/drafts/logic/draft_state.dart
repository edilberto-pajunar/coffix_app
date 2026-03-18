part of 'draft_cubit.dart';

@freezed
class DraftState with _$DraftState {
  const factory DraftState.initial() = _Initial;
  const factory DraftState.loading() = _Loading;
  const factory DraftState.success() = _Success;
  const factory DraftState.loaded({required List<DraftItem> drafts}) = _Loaded;
  const factory DraftState.error({required String message}) = _Error;
}
