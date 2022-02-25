import 'package:flutter/material.dart';
import 'package:habit_tracker_app/classes/habit.dart';
import 'package:habit_tracker_app/providers/habit_provider.dart';
import 'package:habit_tracker_app/screens/edit_habit_screen.dart';
import 'package:provider/provider.dart';

class HabitWidget extends StatelessWidget {
  final Habit habit;
  const HabitWidget(this.habit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final habitsProvider = Provider.of<HabitProvider>(context);
    return Opacity(
      opacity: habit.isSelected ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Color(habit.colorValue),
            borderRadius: BorderRadius.circular(20)),
        child: FittedBox(
          fit: BoxFit.contain,
          child: TextButton.icon(
            onPressed: () {
              habitsProvider.selectHabit(habit.id);
            },
            icon: Icon(IconData(habit.iconCodePoint,
                fontFamily: habit.iconFontFamily,
                fontPackage: habit.iconFontPackage)),
            label: Text(habit.name),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor:
                    MaterialStateProperty.all(Color(habit.colorValue))),
            onLongPress: () {
              Navigator.of(context)
                  .pushNamed(EditHabitScreen.routeName, arguments: habit.id);
            },
          ),
        ),
      ),
    );
  }
}
