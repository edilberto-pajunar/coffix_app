// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'global.g.dart';

@JsonSerializable(explicitToJson: true)
class AppGlobal extends Equatable {
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
  final int? invoiceCounter;
  final double? creditExpiryDuration;

  const AppGlobal({
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
    this.invoiceCounter,
    this.creditExpiryDuration,
  });

  factory AppGlobal.fromJson(Map<String, dynamic> json) =>
      _$AppGlobalFromJson(json);
  Map<String, dynamic> toJson() => _$AppGlobalToJson(this);

  AppGlobal copyWith({
    double? GST,
    String? appVersion,
    double? basicDiscount,
    double? discountLevel2,
    double? discountLevel3,
    double? maxDayBetweenLogin,
    double? minCreditToShare,
    double? minTopUp,
    String? specialUrl,
    String? storeUrl,
    String? tcUrl,
    double? topupLevel2,
    double? topupLevel3,
    double? withdrawalFee,
    int? invoiceCounter,
    double? creditExpiryDuration,
  }) => AppGlobal(
    GST: GST ?? this.GST,
    appVersion: appVersion ?? this.appVersion,
    basicDiscount: basicDiscount ?? this.basicDiscount,
    discountLevel2: discountLevel2 ?? this.discountLevel2,
    discountLevel3: discountLevel3 ?? this.discountLevel3,
    maxDayBetweenLogin: maxDayBetweenLogin ?? this.maxDayBetweenLogin,
    minCreditToShare: minCreditToShare ?? this.minCreditToShare,
    minTopUp: minTopUp ?? this.minTopUp,
    specialUrl: specialUrl ?? this.specialUrl,
    storeUrl: storeUrl ?? this.storeUrl,
    tcUrl: tcUrl ?? this.tcUrl,
    topupLevel2: topupLevel2 ?? this.topupLevel2,
    topupLevel3: topupLevel3 ?? this.topupLevel3,
    withdrawalFee: withdrawalFee ?? this.withdrawalFee,
    invoiceCounter: invoiceCounter ?? this.invoiceCounter,
    creditExpiryDuration: creditExpiryDuration ?? this.creditExpiryDuration,
  );

  @override
  List<Object?> get props => [
    GST,
    appVersion,
    basicDiscount,
    discountLevel2,
    discountLevel3,
    maxDayBetweenLogin,
    minCreditToShare,
    minTopUp,
    specialUrl,
    storeUrl,
    tcUrl,
    topupLevel2,
    topupLevel3,
    withdrawalFee,
    invoiceCounter,
    creditExpiryDuration,
  ];
}
