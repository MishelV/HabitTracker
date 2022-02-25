import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/classes/habit.dart';
import 'package:habit_tracker_app/classes/record.dart';
import 'package:habit_tracker_app/providers/habit_provider.dart';
import 'package:habit_tracker_app/providers/record_provider.dart';
import 'package:habit_tracker_app/utils/date_time_util.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class RecordHabitScreen extends StatefulWidget {
  const RecordHabitScreen({Key? key}) : super(key: key);

  static const routeName = '/record-habit';

  @override
  State<RecordHabitScreen> createState() => _RecordHabitScreenState();
}

class _RecordHabitScreenState extends State<RecordHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _startTime =
      DateFormat(DateTimeUtil.DATE_FORMAT).format(DateTime.now());
  int _durationInMinutes = 0;
  String? _habitId;
  String _description = '';
  bool _isLoading = false;
  bool _isOtherDuration = false;

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_startTime == null) print("habit time null");
    if (_durationInMinutes == null) print("_habitDuration null");
    if (_habitId == null) print("_habitId null");

    if (_startTime == null || _habitId == null || _durationInMinutes == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Please fill all the fields!",
            style: TextStyle(backgroundColor: Colors.red),
          ),
        ),
      );
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    Provider.of<RecordProvider>(context, listen: false).addRecord(Record(
        recordId: "record_" +
            DateTime(2022).difference(DateTime.now()).inSeconds.toString(),
        habitId: _habitId!,
        durationInMinutes: _durationInMinutes,
        startTime: _startTime!,
        description: _description));

    setState(() {
      _isLoading = false;
    });
    FocusManager.instance.primaryFocus?.unfocus();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hurray!"),
        content: const Text("Your habit record was submitted."),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
              child: const Text("Back to main screen")),
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _formKey.currentState!.reset();
                setState(() {
                  _startTime = DateTime.now().toString();
                  _durationInMinutes = 0;
                  _habitId = null;
                  _isLoading = false;
                  _isOtherDuration = false;
                });
              },
              child: const Text("Submit another one!")),
        ],
      ),
    );
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    List<Habit> habits = habitProvider.habits;
    String? habitName;
    if (_habitId != null) {
      habitName = habitProvider.getHabitById(_habitId!).name;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Record a habit"),
          actions: [
            IconButton(
                onPressed: _saveForm, icon: const Icon(MdiIcons.tapeDrive))
          ],
        ),
        body: Form(
            key: _formKey,
            child:
                ListView(padding: const EdgeInsets.all(40), children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              DropdownButtonFormField<String>(
                  isDense: true,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please pick a habit!";
                    }
                    return null;
                  },
                  hint: habitName == null
                      ? const Text("Pick a habit!")
                      : Text(habitName),
                  items: habits.map((habit) {
                    return DropdownMenuItem<String>(
                      child: Container(
                        color: Color(habit.colorValue),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(IconData(habit.iconCodePoint,
                                fontFamily: habit.iconFontFamily,
                                fontPackage: habit.iconFontPackage)),
                            Text(habit.name)
                          ],
                        ),
                      ),
                      value: habit.id,
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(
                        () {
                          _habitId = val;
                        },
                      );
                    }
                  }),
              const SizedBox(
                height: 30,
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2022),
                lastDate: DateTime.now(),
                use24HourFormat: true,
                dateMask: "dd/MM/yyyy",
                dateLabelText: 'Date',
                timeLabelText: 'Starting time',
                onSaved: (val) {
                  _startTime = val;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownButtonFormField<String>(
                  isDense: true,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please set duration for habit!";
                    }
                    return null;
                  },
                  hint: !_isOtherDuration && _durationInMinutes == 0
                      ? const Text("Set duration time!")
                      : _isOtherDuration
                          ? const Text("Other")
                          : Text("$_durationInMinutes minutes"),
                  items: [10, 20, 30, 60, 90, 120, 0].map((durationInMinutes) {
                    return DropdownMenuItem<String>(
                      child: Container(
                        height: 40,
                        child: durationInMinutes == 0
                            ? const Text("Other")
                            : Text("$durationInMinutes minutes"),
                      ),
                      value: durationInMinutes.toString(),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(
                        () {
                          _durationInMinutes = int.parse(val);
                          if (_durationInMinutes == 0) {
                            _isOtherDuration = true;
                          } else {
                            _isOtherDuration = false;
                          }
                        },
                      );
                    }
                  }),
              const SizedBox(
                height: 30,
              ),
              if (_isOtherDuration)
                TextFormField(
                  // The validator receives the text that the user has entered.
                  initialValue: "0",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please add custom duration!';
                    }
                    try {
                      _durationInMinutes = value != null ? int.parse(value) : 0;
                      return null;
                    } catch (_) {
                      return 'Please add custom duration!';
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Duration in minutes",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value != null || value == "") {
                      setState(() {
                        try {
                          _durationInMinutes = int.parse(value);
                        }
                        // ignore: empty_catches
                        catch (_) {}
                      });
                    }
                  },
                ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                initialValue: "",
                validator: (value) {},
                decoration: const InputDecoration(
                  labelText: "Description (Optional)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(onPressed: _saveForm, child: const Text("Submit!"))
            ])));
  }
}
