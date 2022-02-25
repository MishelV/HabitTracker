import 'package:flutter/material.dart';
import 'package:habit_tracker_app/classes/habit.dart';
import 'package:habit_tracker_app/classes/record.dart';
import 'package:habit_tracker_app/helpers/notification_helper.dart';
import 'package:habit_tracker_app/providers/habit_provider.dart';
import 'package:habit_tracker_app/providers/record_provider.dart';
import 'package:habit_tracker_app/screens/edit_habit_screen.dart';
import 'package:habit_tracker_app/screens/habit_choice_screen.dart';
import 'package:habit_tracker_app/screens/main_screen.dart';
import 'package:habit_tracker_app/screens/record_charts_screen.dart';
import 'package:habit_tracker_app/screens/record_habit_screen.dart';
import 'package:habit_tracker_app/screens/records_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

late Box hive;
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(RecordAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => HabitProvider()),
      ChangeNotifierProvider(create: (_) => RecordProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: const MainScreen(),
      routes: {
        HabitChoiceScreen.routeName: (ctx) => const HabitChoiceScreen(),
        EditHabitScreen.routeName: (ctx) => EditHabitScreen(),
        MainScreen.routeName: (ctx) => const MainScreen(),
        RecordHabitScreen.routeName: (ctx) => const RecordHabitScreen(),
        RecordsScreen.routeName: (ctx) => const RecordsScreen(),
        RecordChartsScreen.routeName: (ctx) => const RecordChartsScreen(),
      },
    );
  }
}
