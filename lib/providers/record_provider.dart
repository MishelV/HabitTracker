import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/classes/record.dart';
import 'package:habit_tracker_app/helpers/db_helper.dart';

class RecordProvider with ChangeNotifier {
  List<Record> _records = [];

  Future<void> fetchAndSetRecords() async {
    _records = await DBHelper().getRecords();
    notifyListeners();
  }

  RecordProvider() {
    fetchAndSetRecords();
  }

  get records {
    var copiedRecords = [..._records];
    copiedRecords.sort((r1, r2) => r1.recordId.compareTo(r1.recordId));
    return copiedRecords;
  }

  void addRecord(Record record) {
    _records.add(record);
    DBHelper().addRecord(record);
    notifyListeners();
  }

  Record getRecordById(String id) {
    return _records.firstWhere((element) => (element.recordId == id));
  }

  List<Record> getRecordsByHabitId(String id) {
    List<Record> habitRecords = [];
    for (var element in _records) {
      if (element.habitId == id) {
        habitRecords.add(element);
      }
    }
    return habitRecords;
  }

  void removeRecordById(String id) {
    if (id.isEmpty) return;
    Record record = getRecordById(id);
    DBHelper().removeRecord(record);
    _records.remove(record);
    notifyListeners();
  }

  void removeRecordsByHabitId(String id) {
    if (id.isEmpty) return;
    List<Record> records = getRecordsByHabitId(id);
    for (var r in records) {
      DBHelper().removeRecord(r);
      _records.remove(r);
    }

    notifyListeners();
  }

  void clearRecords() {
    _records.clear();
    DBHelper().clearRecords();
    notifyListeners();
  }
}
