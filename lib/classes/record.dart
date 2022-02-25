import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType(typeId: 2)
class Record {
  @HiveField(0)
  String recordId;

  @HiveField(1)
  String habitId;

  @HiveField(2)
  String startTime;

  @HiveField(3)
  int durationInMinutes;

  @HiveField(4)
  String description;

  Record({
    required this.recordId,
    required this.habitId,
    required this.startTime,
    required this.durationInMinutes,
    this.description = '',
  });
}
