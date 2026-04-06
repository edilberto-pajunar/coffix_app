import 'package:coffix_app/features/coupons/data/model/coupon.dart';

abstract class CouponRepository {
  Stream<List<Coupon>> streamCoupons();
}
