import 'package:habit_tracker_app/classes/record.dart';
import 'package:hive/hive.dart';
import '../classes/habit.dart';
import 'package:flutter/material.dart';

class DBHelper {
  void initHive() {}

  // Habits
  get habitBox async {
    return await Hive.openBox('habits');
  }

  Future<List<Habit>> getHabits() async {
    List<Habit> habits = [];
    Box hive = await habitBox;
    List<String>? listOfIds = hive.get('habitIds');
    if (listOfIds == null) return [];
    for (final id in listOfIds) {
      final habit = hive.get(id);
      if (habit != null) habits.add(habit);
    }
    return habits;
  }

  void addHabit(Habit habit) async {
    Box hive = await habitBox;
    List<String>? listOfIds = hive.get('habitIds');
    listOfIds ??= [];
    listOfIds.add(habit.id);
    hive.put('habitIds', listOfIds);
    hive.put(habit.id, habit);
  }

  void removeHabit(Habit habit) async {
    Box hive = await habitBox;
    List<String>? listOfIds = hive.get('habitIds');
    listOfIds ??= [];
    listOfIds.remove(habit.id);
    hive.put('habitIds', listOfIds);
    hive.delete(habit.id);
  }

  void clearHabits() async {
    Box hive = await habitBox;
    hive.clear();
  }

  // Records

  get recordBox async {
    return await Hive.openBox('records');
  }

  Future<List<Record>> getRecords() async {
    List<Record> records = [];
    Box hive = await recordBox;
    List<String>? listOfIds = hive.get('recordIds');
    if (listOfIds == null) return [];
    for (final id in listOfIds) {
      final record = hive.get(id);
      if (record != null) records.add(record);
    }
    return records;
  }

  void addRecord(Record record) async {
    Box hive = await recordBox;
    List<String>? listOfIds = hive.get('recordIds');
    listOfIds ??= [];
    listOfIds.add(record.recordId);
    hive.put('recordIds', listOfIds);
    hive.put(record.recordId, record);
  }

  void removeRecord(Record record) async {
    Box hive = await recordBox;
    List<String>? listOfIds = hive.get('recordIds');
    listOfIds ??= [];
    listOfIds.remove(record.recordId);
    hive.put('recordIds', listOfIds);
    hive.delete(record.recordId);
  }

  void clearRecords() async {
    Box hive = await recordBox;
    hive.clear();
  }
}
