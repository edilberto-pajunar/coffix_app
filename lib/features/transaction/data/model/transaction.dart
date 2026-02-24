import 'package:coffix_app/core/utils/date_time_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.g.dart';

enum TransactionStatus {
  @JsonValue('created')
  created,
  @JsonValue('paid')
  paid,
  @JsonValue('failed')
  failed,
  @JsonValue('approved')
  approved,
}

@JsonSerializable()
class Transaction {
  final String? docId;
  final String? orderId;
  final String? customerId;
  final double? amount;
  @DateTimeConverter()
  final DateTime? createdAt;
  final TransactionStatus? status;
  final String? paymentMethod;
  final String? paymentId;
  @DateTimeConverter()
  final DateTime? paymentTime;

  Transaction({
    this.docId,
    this.orderId,
    this.customerId,
    this.amount,
    this.createdAt,
    this.status,
    this.paymentMethod,
    this.paymentId,
    this.paymentTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
