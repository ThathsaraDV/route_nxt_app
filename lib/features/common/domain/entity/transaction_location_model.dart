import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_location_model.g.dart';

@JsonSerializable()
class TransactionLocationModel {
  String id = '';
  String lat;
  String long;
  double price;

  TransactionLocationModel(this.lat, this.long, this.price);

  factory TransactionLocationModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionLocationModelToJson(this);

}