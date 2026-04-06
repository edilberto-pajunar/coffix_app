part of 'coupon_cubit.dart';

@freezed
abstract class CouponState with _$CouponState {
  const factory CouponState.initial() = _Initial;
  const factory CouponState.loading() = _Loading;
  const factory CouponState.loaded({required List<Coupon> coupons}) = _Loaded;
  const factory CouponState.error({required String message}) = _Error;
}
