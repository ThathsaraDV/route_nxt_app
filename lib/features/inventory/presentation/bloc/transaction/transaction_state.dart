part of 'transaction_cubit.dart';

@freezed
abstract class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;

  const factory TransactionState.loading() = _Loading;

  const factory TransactionState.loaded(
      List<TransactionModel> transactionList, bool hasMore) = _Loaded;

  const factory TransactionState.loadingFailed(String message) = _LoadingFailed;
}
