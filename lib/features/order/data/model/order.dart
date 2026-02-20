
import 'package:coffix_app/core/utils/date_time_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  final String? docId;
  final String? customerId;
  final String? storeId;
  final double? total;
  @DateTimeConverter()
  final DateTime? createdAt;
  @DateTimeConverter()
  final DateTime? scheduledAt;
  final String? orderNumber;

  Order({
    this.docId,
    this.customerId,
    this.storeId,
    this.total,
    this.createdAt,
    this.scheduledAt,
    this.orderNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}