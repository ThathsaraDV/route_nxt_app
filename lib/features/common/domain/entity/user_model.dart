import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? id;
  String? email;
  String? displayName;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? password;

  UserModel({this.id, this.email, this.displayName, this.password});

  UserModel.withEmailAndPassword({this.email, this.password});

  UserModel.noArgs() {
    id = null;
    email = null;
    displayName = null;
    password = null;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

}