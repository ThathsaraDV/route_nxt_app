import 'package:cloud_firestore/cloud_firestore.dart';

class DistanceService {
  final FirebaseFirestore _firebaseFirestore;

  DistanceService(this._firebaseFirestore);

  Future<void> addDistance(String uid, double distance) async {
    try {
      var documentReference = _firebaseFirestore
          .collection('sales')
          .doc(uid)
          .collection('distance')
          .doc();
      documentReference.set({
        "id": documentReference.id,
        "createdDate" : Timestamp.fromDate(DateTime.now()),
        "distance" : distance
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getDistanceThisWeek(String uid) async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      startOfWeek =
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('sales')
          .doc(uid)
          .collection('distance')
          .where('createdDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
          .get();

      double totalDistance = querySnapshot.docs.fold(0.0, (distance, doc) {
        return distance + doc['distance'];
      });
      return totalDistance;
    } catch (e) {
      rethrow;
    }
  }
}
