import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/classes/habit.dart';
import 'package:habit_tracker_app/helpers/db_helper.dart';
import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];

  Future<void> fetchAndSetHabits() async {
    _habits = await DBHelper().getHabits();
    notifyListeners();
  }

  HabitProvider() {
    fetchAndSetHabits();
  }

  get habits {
    var copiedHabits = [..._habits];
    copiedHabits.sort((h1, h2) => h1.id.compareTo(h2.id));
    return copiedHabits;
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    DBHelper().addHabit(habit);
    notifyListeners();
  }

  Habit getHabit(String name) {
    return _habits.firstWhere((element) => (element.name == name));
  }

  Habit getHabitById(String id) {
    return _habits.firstWhere((element) => (element.id == id));
  }

  void removeHabitById(String id) {
    if (id.isEmpty) return;
    Habit habit = getHabitById(id);
    DBHelper().removeHabit(habit);
    _habits.remove(habit);
    notifyListeners();
  }

  Habit? randomlyChooseHabitFromSelected() {
    List<Habit> selectedHabitNames = [];
    for (var element in _habits) {
      if (element.isSelected) selectedHabitNames.add(element);
    }
    if (selectedHabitNames.isEmpty) return null;
    final randomIndex = Random().nextInt(selectedHabitNames.length);
    return selectedHabitNames[randomIndex];
  }

  void selectHabit(String id) {
    _habits.forEach((element) {
      if (element.id == id) {
        element.isSelected = !element.isSelected;
      }
    });
    notifyListeners();
  }

  void clearHabits() {
    _habits.clear();
    DBHelper().clearHabits();
    notifyListeners();
  }

  int numberOfSelected() {
    var counter = 0;
    for (var element in _habits) {
      if (element.isSelected) ++counter;
    }
    return counter;
  }
}
