import 'package:flutter/material.dart';
import 'package:habit_tracker_app/providers/record_provider.dart';
import 'package:habit_tracker_app/screens/edit_habit_screen.dart';
import 'package:habit_tracker_app/screens/habit_choice_screen.dart';
import 'package:habit_tracker_app/screens/record_charts_screen.dart';
import 'package:habit_tracker_app/screens/record_habit_screen.dart';
import 'package:habit_tracker_app/screens/records_screen.dart';
import 'package:habit_tracker_app/widgets/screen_selection_button.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const routeName = '/main_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/HabitManagerLogo.png"),
            const SizedBox(
              height: 70,
            ),
            const ScreenSelectionButton(
              EditHabitScreen.routeName,
              "Add new habit",
              arguments: "",
            ),
            const ScreenSelectionButton(
                HabitChoiceScreen.routeName, "Get a random habit"),
            const ScreenSelectionButton(
                RecordHabitScreen.routeName, "Record a habit"),
            const ScreenSelectionButton(
                RecordsScreen.routeName, "See habit records"),
            const ScreenSelectionButton(
                RecordChartsScreen.routeName, "See records analysis"),
            const ScreenSelectionButton("", "Explore new habits"),
            // TextButton(
            //     onPressed: Provider.of<RecordProvider>(context).clearRecords,
            //     child: Text(
            //       "CLEAR ALL RECORDS!",
            //       style: TextStyle(color: Theme.of(context).errorColor),
            //     ))
          ],
        ),
      ),
    );
  }
}
