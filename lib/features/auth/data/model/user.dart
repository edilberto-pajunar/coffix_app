import 'package:coffix_app/core/utils/date_time_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class AppUser {
  final String docId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? nickName;
  final String? mobile;
  @DateTimeConverter()
  final DateTime? birthday;
  final String? suburb;
  final String? city;
  final String? preferredStore;
  @DateTimeConverter()
  final DateTime? createdAt;

  AppUser({
    required this.docId,
    required this.email,
    this.firstName,
    this.lastName,
    this.nickName,
    this.mobile,
    this.birthday,
    this.suburb,
    this.city,
    this.preferredStore,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
