import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  String? id;
  String? name;
  String? code;
  double? buying;
  double? selling;
  int? quantity;
  double? discount;
  @TimestampConverter()
  DateTime? createdDate;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? uid;
  bool? status;

  ProductModel(
      {this.id,
      this.name,
      this.code,
      this.buying,
      this.selling,
      this.quantity,
      this.discount,
      this.createdDate,
      this.status});

  ProductModel.noArgs() {
    id = null;
    name = null;
    code = null;
    buying = null;
    selling = null;
    quantity = null;
    discount = null;
    createdDate = null;
    uid = null;
    status = null;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
