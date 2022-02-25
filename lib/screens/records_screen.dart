import 'package:flutter/material.dart';
import 'package:habit_tracker_app/classes/habit.dart';
import 'package:habit_tracker_app/classes/record.dart';
import 'package:habit_tracker_app/providers/habit_provider.dart';
import 'package:habit_tracker_app/providers/record_provider.dart';
import 'package:habit_tracker_app/screens/record_habit_screen.dart';
import 'package:habit_tracker_app/widgets/record_card.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({Key? key}) : super(key: key);

  static const routeName = '/records';

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  void deleteRecord(Record record, String habitName) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("What??"),
        content: Text(
            "Are you sure you wish to delete the record of '$habitName' from ${record.startTime}?"),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("Abort!")),
          ElevatedButton(
              onPressed: () {
                Provider.of<RecordProvider>(context, listen: false)
                    .removeRecordById(record.recordId);
                Navigator.of(ctx).pop();
              },
              child: const Text("Delete!"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final records = Provider.of<RecordProvider>(context).records.reversed;
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Records"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RecordHabitScreen.routeName);
            },
            icon: const Icon(MdiIcons.checkboxMarkedCirclePlusOutline),
          ),
        ],
      ),
      body: ListView.builder(
        // reverse: true,
        itemBuilder: (context, index) {
          final record = records.elementAt(index);
          final habit = habitProvider.getHabitById(record.habitId);
          return RecordCard(habit, record, deleteRecord);
        },
        itemCount: records.length,
      ),
    );
  }
}
