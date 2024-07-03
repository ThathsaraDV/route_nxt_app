part of 'reminder_cubit.dart';

@freezed
abstract class ReminderState with _$ReminderState {
  const factory ReminderState.initial() = _Initial;

  const factory ReminderState.historyLoading() = _HistoryLoading;

  const factory ReminderState.historyLoaded(List<ReminderModel> reminderList) =
      _HistoryLoaded;

  const factory ReminderState.emptyHistoryLoaded(
      List<ReminderModel> reminderList) = _EmptyHistoryLoaded;

  const factory ReminderState.historyLoadingFailed(String message) =
      _HistoryLoadingFailed;

  const factory ReminderState.savingReminder() = _SavingReminder;

  const factory ReminderState.savedReminder(ReminderModel reminder) =
      _SavedReminder;

  const factory ReminderState.savingReminderFailed(String message) =
      _SavingReminderFailed;

  const factory ReminderState.deletingReminder() = _DeletingReminder;

  const factory ReminderState.deletedReminder(int id) = _DeletedReminder;

  const factory ReminderState.deletingReminderFailed(String message) =
      _DeletingReminderFailed;
}
