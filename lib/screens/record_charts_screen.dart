import 'package:flutter/material.dart';
import 'package:habit_tracker_app/classes/habit.dart';
import 'package:habit_tracker_app/classes/record.dart';
import 'package:habit_tracker_app/providers/habit_provider.dart';
import 'package:habit_tracker_app/providers/record_provider.dart';
import 'package:habit_tracker_app/utils/date_time_util.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RecordChartsScreen extends StatelessWidget {
  const RecordChartsScreen({Key? key}) : super(key: key);

  static const routeName = '/record-charts';

  @override
  Widget build(BuildContext context) {
    final recordProvider = Provider.of<RecordProvider>(context);
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Records Report"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: const Poop(),
              // height: 100,
            ),
            Container(
              child: StackedChart(),
              height: 200,
            ),
          ],
        ));
  }
}

class Poop extends StatelessWidget {
  const Poop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recordProvider = Provider.of<RecordProvider>(context);
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Habit habit = habitProvider.habits[index];
        List<Record> recordsList = recordProvider.getRecordsByHabitId(habit.id);
        return Container(
          child: Card(
            child: Text(
                "Found ${recordsList.length} records of habit ${habit.name}. Duration sum: ${recordsList.fold(0, (int previousValue, Record element) => previousValue + element.durationInMinutes)} minutes."),
          ),
        );
      },
      itemCount: habitProvider.habits.length,
    );
  }
}

class RecordData {
  /// Holds the datapoint values like x, y, etc.,
  RecordData(
      {required this.days,
      required this.habitName,
      required this.durations,
      this.pointColor});

  final String habitName;
  final Map<int, String> days;
  final Map<int, int> durations;
  final Color? pointColor;
}

class StackedChart extends StatefulWidget {
  StackedChart({Key? key}) : super(key: key);

  @override
  State<StackedChart> createState() => _StackedChartState();
}

extension on DateTime {
  DateTime roundDown({Duration delta = const Duration(days: 1)}) {
    return DateTime.fromMillisecondsSinceEpoch(this.millisecondsSinceEpoch -
        this.millisecondsSinceEpoch % delta.inMilliseconds);
  }
}

class _StackedChartState extends State<StackedChart> {
  bool _isInit = true;
  bool _isLoading = false;
  List<StackedColumnSeries<RecordData, String>>? chartData;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isInit = false;

        _isLoading = true;
      });
      Provider.of<HabitProvider>(context, listen: false)
          .fetchAndSetHabits()
          .then((_) {
        Provider.of<RecordProvider>(context, listen: false)
            .fetchAndSetRecords()
            .then((_) {
          setState(() {
            chartData = _getStackedColumnSeries();

            _isLoading = false;
          });
        });
      });
    }
    super.didChangeDependencies();
  }

  List<RecordData> getRecordsData() {
    List<RecordData> data = [];
    final recordProvider = Provider.of<RecordProvider>(context, listen: false);
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    for (final Habit habit in habitProvider.habits) {
      final List<Record> records = recordProvider.getRecordsByHabitId(habit.id);
      Map<int, String> days = {};
      Map<int, int> durations = {};
      for (final record in records) {
        final DateTime dt =
            DateTimeUtil().getDateTime(record.startTime).roundDown();
        final index = DateTime.now().roundDown().difference(dt).inDays;
        days[index] = DateFormat('dd/MM').format(dt);
        durations[index] = durations[index] == null
            ? record.durationInMinutes
            : (durations[index]! + record.durationInMinutes);
      }
      for (int i = 0; i < 7; ++i) {
        if (!days.containsKey(i)) {
          final date = i == 0
              ? DateTime.now()
              : DateTime.now().roundDown(delta: Duration(days: i));
          days[i] = DateFormat('dd/MM').format(date);
          durations[i] = 0;
        }
      }
      // NEED TO SET THE DATE IN THE INIT AND NOT IN THE BUIULD! REDO!
      data.add(RecordData(
          days: days,
          habitName: habit.name,
          durations: durations,
          pointColor: Color(habit.colorValue)));
    }
    return data;
  }

  // List<RecordData> chartData = <ChartSampleData>[
  List<StackedColumnSeries<RecordData, String>> _getStackedColumnSeries() {
    List<RecordData> chartData = getRecordsData();
    List<StackedColumnSeries<RecordData, String>> values = [];
    for (final r in chartData) {
      values.add(
        StackedColumnSeries<RecordData, String>(
          dataSource: chartData,
          xValueMapper: (RecordData p, i) =>
              r.days.containsKey(i) ? r.days[i] : '',
          yValueMapper: (RecordData p, i) =>
              r.durations.containsKey(i) ? r.durations[i] : 0,
          name: r.habitName,
          color: r.pointColor,
        ),
      );
    }
    return values;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SfCartesianChart(
            plotAreaBorderWidth: 0,
            title: ChartTitle(text: 'Weekly Habits Activity Report'),
            legend: Legend(
                isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                labelFormat: '{value} Minutes',
                majorTickLines: const MajorTickLines(size: 0)),
            series: chartData,
          );
  }
}
