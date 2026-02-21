// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'global.g.dart';

@JsonSerializable()
class AppGlobal {
  final double? GST;
  final String? appVersion;
  final double? basicDiscount;
  final double? discountLevel2;
  final double? discountLevel3;
  final double? maxDayBetweenLogin;
  final double? minCreditToShare;
  final double? minTopUp;
  final String? specialUrl;
  final String? storeUrl;
  final String? tcUrl;
  final double? topupLevel2;
  final double? topupLevel3;
  final double? withdrawalFee;

  AppGlobal({
    this.GST,
    this.appVersion,
    this.basicDiscount,
    this.discountLevel2,
    this.discountLevel3,
    this.maxDayBetweenLogin,
    this.minCreditToShare,
    this.minTopUp,
    this.specialUrl,
    this.storeUrl,
    this.tcUrl,
    this.topupLevel2,
    this.topupLevel3,
    this.withdrawalFee,
  });

  factory AppGlobal.fromJson(Map<String, dynamic> json) =>
      _$AppGlobalFromJson(json);
  Map<String, dynamic> toJson() => _$AppGlobalToJson(this);
}
