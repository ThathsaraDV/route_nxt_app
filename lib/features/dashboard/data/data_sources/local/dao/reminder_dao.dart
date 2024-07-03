import 'package:floor/floor.dart';
import 'package:route_nxt/features/dashboard/data/models/reminder_model.dart';

@dao
abstract class ReminderDao{

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> saveReminder(ReminderModel reminder);

  @Query('SELECT * FROM reminder')
  Future<List<ReminderModel>> getAllReminders();

  @Query('DELETE FROM reminder')
  Future<void> deleteAll();

  @Query('Delete from reminder where id=:id')
  Future<void> deleteReminderById(int id);
}