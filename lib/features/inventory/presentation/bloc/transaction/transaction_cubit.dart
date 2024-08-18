import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/data/data_sources/auth_service.dart';
import 'package:route_nxt/features/common/data/data_sources/transaction_service.dart';
import 'package:route_nxt/features/common/domain/entity/transaction_model.dart';
import 'package:route_nxt/features/inventory/data/models/transaction_fetch_result.dart';

part 'transaction_state.dart';

part 'transaction_cubit.freezed.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionService _transactionService;
  final AuthService _authService;
  final int _limit = 10;
  DocumentSnapshot? _lastDocument;
  bool _isFetching = false;

  TransactionCubit(this._transactionService, this._authService)
      : super(const TransactionState.initial());

  void fetchTransactions() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      state.maybeWhen(
        initial: () {
          emit(const TransactionState.loading());
        },
        orElse: () {},
      );
      var currentUser = _authService.getCurrentUser();
      if (null != currentUser) {
        final TransactionFetchResult result = await _transactionService
            .fetchTransactions(currentUser.uid, _limit, _lastDocument);

        _lastDocument = result.lastDocument;
        final List<TransactionModel> transactionList = result.transactions;
        final hasMore = transactionList.length == _limit;

        state.maybeWhen(
          loaded: (currentTransactionList, currentHasMore) {
            emit(TransactionState.loaded(
                currentTransactionList + transactionList, hasMore));
          },
          orElse: () {
            emit(TransactionState.loaded(transactionList, hasMore));
          },
        );
      } else {
        throw Exception("Internal Server Error");
      }
    } catch (e) {
      emit(const TransactionState.loadingFailed("Data Fetching Failed"));
    } finally {
      _isFetching = false;
    }
  }

  void refreshTransactions() {
    _lastDocument = null;
    emit(const TransactionState.initial());
    fetchTransactions();
  }
}
