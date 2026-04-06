import 'package:coffix_app/core/utils/date_time_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.g.dart';

@JsonSerializable()
class Coupon {
  final String? docId;
  final String? code;
  final String? type;
  final double? amount;
  @DateTimeConverter()
  final DateTime? expiryDate;
  final String? storeId;
  final String? notes;
  final List<String>? userIds;
  final int? usageLimit;
  final int? usageCount;
  final String? source;
  final String? referralId;
  final bool? isUsed;
  @DateTimeConverter()
  final DateTime? createdAt;

  Coupon({
    this.docId,
    this.code,
    this.type,
    this.amount,
    this.expiryDate,
    this.storeId,
    this.notes,
    this.userIds,
    this.usageLimit,
    this.usageCount,
    this.source,
    this.referralId,
    this.isUsed,
    this.createdAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
  Map<String, dynamic> toJson() => _$CouponToJson(this);
}
