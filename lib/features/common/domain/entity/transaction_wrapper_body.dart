import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_location_model.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_model.dart';

part 'transaction_wrapper_body.g.dart';

@JsonSerializable()
class TransactionWrapperBody {
  TransactionModel transaction;
  TransactionLocationModel location;

  TransactionWrapperBody(this.transaction, this.location);

  factory TransactionWrapperBody.fromJson(Map<String, dynamic> json) =>
      _$TransactionWrapperBodyFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionWrapperBodyToJson(this);

}