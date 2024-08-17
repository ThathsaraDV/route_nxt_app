import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_location_model.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_model.dart';
import 'package:route_nxt/features/inventory/data/models/transaction_fetch_result.dart';

class TransactionService {
  final FirebaseFirestore _firebaseFirestore;

  TransactionService(this._firebaseFirestore);

  Future<TransactionModel> saveTransaction(String uid, String locationId,
      TransactionModel transaction, WriteBatch batch) async {
    try {
      var documentReference = _firebaseFirestore
          .collection('sales')
          .doc(uid)
          .collection("transaction")
          .doc();
      transaction.id = documentReference.id;
      transaction.locationId = locationId;
      batch.set(documentReference, transaction.toJson());
      return transaction;
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionLocationModel> saveTransactionLocation(
      String uid, TransactionLocationModel location, WriteBatch batch) async {
    try {
      var documentReference = _firebaseFirestore
          .collection('sales')
          .doc(uid)
          .collection("location")
          .doc();
      location.id = documentReference.id;
      batch.set(documentReference, location.toJson());
      return location;
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionFetchResult> fetchTransactions(
      String uid, int limit, DocumentSnapshot? lastDocument) async {
    Query query = _firebaseFirestore
        .collection('sales')
        .doc(uid)
        .collection('transaction')
        .orderBy('createdDate', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot querySnapshot = await query.get();

    List<TransactionModel> transactions = querySnapshot.docs
        .map((doc) =>
            TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    DocumentSnapshot? newLastDocument;
    if (querySnapshot.docs.isNotEmpty) {
      newLastDocument = querySnapshot.docs.last;
    }

    return TransactionFetchResult(
      transactions: transactions,
      lastDocument: newLastDocument,
    );
  }
}
