import 'package:flutter/material.dart';
import 'package:habit_tracker_app/classes/habit.dart';
import 'package:habit_tracker_app/helpers/notification_helper.dart';
import 'package:habit_tracker_app/providers/habit_provider.dart';
import 'package:habit_tracker_app/providers/record_provider.dart';
import 'package:habit_tracker_app/screens/edit_habit_screen.dart';
import 'package:habit_tracker_app/widgets/habit_widget.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

class HabitChoiceScreen extends StatefulWidget {
  const HabitChoiceScreen({Key? key}) : super(key: key);

  static const routeName = '/habit_choice';

  @override
  _HabitChoiceScreenState createState() => _HabitChoiceScreenState();
}

class _HabitChoiceScreenState extends State<HabitChoiceScreen> {
  Habit? _chosenHabit;

  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();
  }

  void showChosenHabit() {
    if (_chosenHabit == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(IconData(_chosenHabit!.iconCodePoint,
                fontFamily: _chosenHabit!.iconFontFamily,
                fontPackage: _chosenHabit!.iconFontPackage)),
            SizedBox(
              width: 10,
            ),
            Text(
              _chosenHabit!.name,
              style: TextStyle(color: Color(_chosenHabit!.colorValue)),
            )
          ],
        ),
        content: Text(_chosenHabit!.description),
        actions: [
          TextButton(
              onPressed: () {
                NotificationService().showNotification(
                    DateTime.now().difference(DateTime(2022)).inSeconds,
                    "Dont forget to record!",
                    "Click here to record the progress of your '${_chosenHabit!.name}' habit!",
                    2);
                Navigator.of(context).pop();
              },
              child: const Text("Will do!")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Maybe later..")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitsProvider = Provider.of<HabitProvider>(context);
    final numberOfSelected = habitsProvider.numberOfSelected();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Habit Chooser"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditHabitScreen.routeName, arguments: "");
              },
              icon: const Icon(Icons.add_sharp)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Container(
              height: 350,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // width: 300,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 4
                      : 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: (2 / 1),
                ),
                itemCount: habitsProvider.habits.length,
                itemBuilder: (context, index) =>
                    HabitWidget(habitsProvider.habits[index]),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 150, height: 150),
            child: ElevatedButton(
              child: Text(
                numberOfSelected == 0 ? 'SELECT HABITS' : 'GET RANDOM HABIT',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              onPressed: numberOfSelected == 0
                  ? null
                  : () {
                      setState(() {
                        _chosenHabit =
                            habitsProvider.randomlyChooseHabitFromSelected();
                      });
                      showChosenHabit();
                    },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  backgroundColor: numberOfSelected == 0
                      ? MaterialStateProperty.all(Colors.grey)
                      : MaterialStateProperty.all(Colors.amber[800])),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
