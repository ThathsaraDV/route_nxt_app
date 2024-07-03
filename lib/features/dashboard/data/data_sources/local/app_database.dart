import 'dart:async';
import 'package:floor/floor.dart';
import 'package:route_nxt/features/dashboard/data/data_sources/local/dao/reminder_dao.dart';
import 'package:route_nxt/features/dashboard/data/models/reminder_model.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [ReminderModel])
abstract class AppDatabase extends FloorDatabase {
  ReminderDao get reminderDao;
}