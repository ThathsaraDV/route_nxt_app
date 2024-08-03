import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:route_nxt/features/common/domain/entity/user_model.dart';

class UserService {
  final FirebaseFirestore _firebaseFirestore;

  UserService(this._firebaseFirestore);

  Future<void> addUser(UserModel user) async {
    CollectionReference users = _firebaseFirestore.collection('users');
    try {
      await users.doc(user.id).set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUser(String uid) async {
    CollectionReference users = _firebaseFirestore.collection('users');
    try {
      DocumentSnapshot user = await users.doc(uid).get();
      if (user.exists) {
        return UserModel.fromJson(user.data() as Map<String, dynamic>);
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      rethrow;
    }
  }
}
