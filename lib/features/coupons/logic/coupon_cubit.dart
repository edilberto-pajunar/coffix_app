import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/repositories/coupon_repository.dart';
import 'package:coffix_app/features/coupons/data/model/coupon.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_state.dart';
part 'coupon_cubit.freezed.dart';

class CouponCubit extends Cubit<CouponState> {
  final CouponRepository _couponRepository;
  StreamSubscription<List<Coupon>>? _couponsSubscription;

  CouponCubit({required CouponRepository couponRepository})
    : _couponRepository = couponRepository,
      super(CouponState.initial());

  void streamCoupons() {
    _couponsSubscription?.cancel();
    emit(CouponState.loading());
    _couponsSubscription = _couponRepository.streamCoupons().listen(
      (coupons) {
        if (!isClosed) emit(CouponState.loaded(coupons: coupons));
      },
      onError: (e) {
        if (!isClosed) emit(CouponState.error(message: e.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _couponsSubscription?.cancel();
    return super.close();
  }
}
