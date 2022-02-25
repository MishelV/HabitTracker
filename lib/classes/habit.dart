import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'habit.g.dart';

// Map<int,String> Repetition {0: 'daily',1: 'weekly', monthly }

class HexColor {}

@HiveType(typeId: 1)
class Habit {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int colorValue;

  @HiveField(3)
  String description;

  @HiveField(4)
  double targetDuration;

  @HiveField(5)
  bool isSelected;

  @HiveField(6)
  int iconCodePoint;

  @HiveField(7)
  String? iconFontFamily;

  @HiveField(8)
  String? iconFontPackage;

  Habit(
      {required this.name,
      required this.colorValue,
      required this.description,
      required this.targetDuration,
      required this.iconCodePoint,
      required this.iconFontFamily,
      required this.iconFontPackage,
      this.isSelected = false,
      this.id = ""});
}
