part of 'otp_cubit.dart';

@freezed
class OtpState with _$OtpState {
  const factory OtpState.initial() = _Initial;

  const factory OtpState.loading() = _Loading;

  const factory OtpState.error({required String message}) = _Error;

  const factory OtpState.otpSent({required String email}) = _OtpSent;

  const factory OtpState.verified() = _Verified;
}
