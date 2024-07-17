import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  UserModel({required this.id, this.email, this.displayName, this.password});

  UserModel.withEmailAndPassword({this.email, this.password});

  final String? email;

  String? id;

  String? displayName;

  final String? password;

  static UserModel empty = UserModel(id: '');

  bool get isEmpty => this == UserModel.empty;

  bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [id, email, displayName, password];
}