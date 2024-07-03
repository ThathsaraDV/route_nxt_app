import 'dart:core';

import 'package:floor/floor.dart';

@Entity(tableName: 'reminder')
class ReminderModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? title;
  final String? body;
  final String? payload;
  final String? scheduledDate;

  ReminderModel(
      this.id, this.title, this.body, this.payload, this.scheduledDate);
}
