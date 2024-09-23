import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_location_model.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_model.dart';
import 'package:route_nxt/features/dashboard/data/models/product_sold_model.dart';
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

  Future<List<ProductSoldModel>> getProductsSoldThisWeek(String uid) async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      startOfWeek =
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('sales')
          .doc(uid)
          .collection('transaction')
          .where('createdDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
          .get();

      Map<String, ProductSoldModel> productsSold = {};

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        List<dynamic> productList = doc['productList'];

        for (var product in productList) {
          String productId = product['productId'];
          String productName = product['name'];
          int quantity = product['quantity'];

          if (productsSold.containsKey(productId)) {
            productsSold[productId] = ProductSoldModel(
              productId: productId,
              productName: productName,
              totalQuantity: productsSold[productId]!.totalQuantity + quantity,
            );
          } else {
            productsSold[productId] = ProductSoldModel(
              productId: productId,
              productName: productName,
              totalQuantity: quantity,
            );
          }
        }
      }

      List<ProductSoldModel> sortedProducts = productsSold.values.toList()
        ..sort((a, b) => b.totalQuantity.compareTo(a.totalQuantity));

      return sortedProducts.take(4).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getNetTotalThisWeek(String uid) async {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    startOfWeek =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('sales')
        .doc(uid)
        .collection('transaction')
        .where('createdDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
        .get();

    double totalNetTotal = 0.0;

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      double netTotal = doc['netTotal'];
      totalNetTotal += netTotal;
    }

    return totalNetTotal;
  }

  Future<Map<String, double>> getNetTotalForEachDayThisWeek(String uid) async {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    startOfWeek =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));
    endOfWeek = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);

    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('sales')
        .doc(uid)
        .collection("transaction")
        .where("createdDate",
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
        .where("createdDate",
            isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek))
        .get();

    Map<String, double> netTotals = {};

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      DateTime createdDate = (data['createdDate'] as Timestamp).toDate();
      String day = DateFormat('EEEE').format(createdDate);

      double netTotal = data['netTotal'] ?? 0;

      if (netTotals.containsKey(day)) {
        netTotals[day] = netTotals[day]! + netTotal;
      } else {
        netTotals[day] = netTotal;
      }
    }

    return netTotals;
  }
}
