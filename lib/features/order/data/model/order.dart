import 'package:coffix_app/core/utils/date_time_converter.dart';
import 'package:coffix_app/features/payment/data/model/payment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.g.dart';

enum OrderStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('pending_payment')
  pendingPayment,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('preparing')
  preparing,
  @JsonValue('ready')
  ready,
  @JsonValue('paid')
  paid,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('pending')
  pending,
}

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
  final OrderStatus? status;
  final PaymentStatus? paymentStatus;

  Order({
    this.docId,
    this.customerId,
    this.storeId,
    this.total,
    this.createdAt,
    this.scheduledAt,
    this.orderNumber,
    this.status,
    this.paymentStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
