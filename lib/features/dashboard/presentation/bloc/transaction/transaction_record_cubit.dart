import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/common/data/data_sources/transaction_service.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_product_model.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_wrapper_body.dart';
import 'package:route_nxt/features/inventory/data/data_sources/inventory_service.dart';

part 'transaction_record_state.dart';

part 'transaction_record_cubit.freezed.dart';

class TransactionRecordCubit extends Cubit<TransactionRecordState> {
  final InventoryService _inventoryService;
  final AuthService _authService;
  final TransactionService _transactionService;
  final FirebaseFirestore _firebaseFirestore;

  TransactionRecordCubit(this._inventoryService, this._authService,
      this._transactionService, this._firebaseFirestore)
      : super(const TransactionRecordState.initial());

  Future<void> saveTransaction(
      TransactionWrapperBody transactionWrapperBody) async {
    try {
      emit(const TransactionRecordState.saving());

      var currentUser = _authService.getCurrentUser();
      if (null != currentUser) {
        var batch = _firebaseFirestore.batch();

        transactionWrapperBody.location =
            await _transactionService.saveTransactionLocation(
                currentUser.uid, transactionWrapperBody.location, batch);

        transactionWrapperBody.transaction =
            await _transactionService.saveTransaction(
                currentUser.uid,
                transactionWrapperBody.location.id,
                transactionWrapperBody.transaction,
                batch);

        for (TransactionProductModel model
            in transactionWrapperBody.transaction.productList) {
          await _inventoryService.updateProductQty(
              currentUser.uid, model, batch);
        }

        await batch.commit();

        emit(TransactionRecordState.saved(transactionWrapperBody));
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const TransactionRecordState.savingFailed("Transaction failed"));
    }
  }
}
