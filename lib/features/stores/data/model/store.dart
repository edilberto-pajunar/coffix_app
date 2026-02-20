import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.g.dart';

@JsonSerializable()
class Store {
  final String? address;
  final bool? disable;
  final String docId;
  final String? gstNumber;
  final String? imageUrl;
  final String? invoiceText;
  final String? location;
  final String? name;
  final String? openingHours;
  final String? storeCode;

  Store({
    this.address,
    this.disable,
    required this.docId,
    this.gstNumber,
    this.imageUrl,
    this.invoiceText,
    this.location,
    this.name,
    this.openingHours,
    this.storeCode,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
