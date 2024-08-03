import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_nxt/features/common/presentation/widgets/custom_snackbar.dart';
import 'package:route_nxt/features/dashboard/data/data_sources/local/dao/reminder_dao.dart';
import 'package:route_nxt/features/dashboard/data/models/reminder_model.dart';
import 'package:timezone/timezone.dart' as tz;

part 'reminder_state.dart';

part 'reminder_cubit.freezed.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final ReminderDao reminderDao;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ReminderCubit(this.reminderDao, this.flutterLocalNotificationsPlugin)
      : super(const ReminderState.initial());

  Future<void> getAllReminders() async {
    try {
      emit(const ReminderState.historyLoading());
      var reminderList = await reminderDao.getAllReminders();
      if (reminderList.isNotEmpty) {
        emit(ReminderState.historyLoaded(reminderList));
      } else {
        emit(ReminderState.emptyHistoryLoaded(reminderList));
      }
    } catch (e) {
      emit(
          const ReminderState.historyLoadingFailed("Loading reminders failed"));
    }
  }

  Future<void> saveReminder(
      ReminderModel reminder, DateTime scheduledDate) async {
    try {
      emit(const ReminderState.savingReminder());
      int savedID = await reminderDao.saveReminder(reminder);
      int inSeconds = scheduledDate.difference(DateTime.now()).inSeconds;
      showScheduledLocalNotification(
          id: savedID,
          title: reminder.title!,
          body: reminder.body!,
          payload: reminder.payload ?? 'clicked',
          seconds: inSeconds);
      emit(ReminderState.savedReminder(reminder));
    } catch (e) {
      emit(const ReminderState.savingReminderFailed("Saving failed"));
    }
  }

  Future<void> deleteReminder(int id) async {
    try {
      emit(const ReminderState.deletingReminder());
      await reminderDao.deleteReminderById(id);
      emit(ReminderState.deletedReminder(id));
    } catch (e) {
      emit(const ReminderState.deletingReminderFailed("Checking failed"));
    }
  }

  Future<void> showScheduledLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required int seconds,
  }) async {
    bool isPermissionsGiven = await checkPermission();
    if (isPermissionsGiven) {
      await scheduleNotification(id, title, body, payload, seconds);
    } else {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();
      bool permissionsGiven = await checkPermission();
      if (permissionsGiven) {
        await scheduleNotification(id, title, body, payload, seconds);
      } else {
        CustomSnackBar.showSnackBar(
            null, 'Please grant notification permissions', 'warning');
      }
    }
  }

  Future<void> scheduleNotification(int id,
      String title,
      String body,
      String payload,
      int seconds,) async {
    final platformChannelSpecifics = await _notificationDetails();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
        platformChannelSpecifics,
        payload: payload,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'route_nxt',
      'route_nxt_channel',
      groupKey: 'com.thathsara.route_nxt',
      channelDescription: 'route nxt notification',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      fullScreenIntent: true,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  Future<bool> checkPermission() async {
    var isNotificationEnabled = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .areNotificationsEnabled() ??
        false;
    var isExactEnabled = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .canScheduleExactNotifications() ??
        false;
    return (isNotificationEnabled && isExactEnabled);
  }

}
