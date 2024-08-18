part of 'transaction_record_cubit.dart';

@freezed
abstract class TransactionRecordState with _$TransactionRecordState {
  const factory TransactionRecordState.initial() = _Initial;

  const factory TransactionRecordState.saving() = _Saving;

  const factory TransactionRecordState.saved(
      TransactionWrapperBody transactionWrapperBody) = _Saved;

  const factory TransactionRecordState.savingFailed(String message) =
      _SavingFailed;
}
