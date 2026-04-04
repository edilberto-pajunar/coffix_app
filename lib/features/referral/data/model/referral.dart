import 'package:coffix_app/core/utils/date_time_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral.g.dart';

@JsonSerializable()
class Referral {
  final String? docId;
  @DateTimeConverter()
  final DateTime? referralTime;
  final String? referrer; // customerID
  final String? referee; // email

  Referral({this.docId, this.referralTime, this.referrer, this.referee});

  factory Referral.fromJson(Map<String, dynamic> json) =>
      _$ReferralFromJson(json);
  Map<String, dynamic> toJson() => _$ReferralToJson(this);
}
