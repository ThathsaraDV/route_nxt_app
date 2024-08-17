import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_model.dart';

class TransactionFetchResult {
  final List<TransactionModel> transactions;
  final DocumentSnapshot? lastDocument;

  TransactionFetchResult({required this.transactions, this.lastDocument});
}