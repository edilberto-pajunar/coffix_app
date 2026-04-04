part of 'referral_cubit.dart';

@freezed
class ReferralState with _$ReferralState {
  const factory ReferralState.initial() = _Initial;
  const factory ReferralState.loading() = _Loading;
  const factory ReferralState.success({required String message}) = _Success;
  const factory ReferralState.error({required String message}) = _Error;
}
