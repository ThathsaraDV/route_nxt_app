import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_product_model.g.dart';

@JsonSerializable()
class TransactionProductModel {
  @JsonKey(includeToJson: false, includeFromJson: false)
  String id = '';
  String productId = '';
  String name;
  int quantity;
  double total;
  double discount;
  @JsonKey(includeToJson: false, includeFromJson: false)
  double sellingPrice = 0.00;
  @JsonKey(includeToJson: false, includeFromJson: false)
  int currentQty = 0;

  TransactionProductModel(
      {required this.name,
      required this.quantity,
      required this.total,
      required this.discount});

  factory TransactionProductModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionProductModelToJson(this);
}
