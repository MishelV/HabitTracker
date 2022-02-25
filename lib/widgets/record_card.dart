import 'dart:math';

import 'package:flutter/material.dart';
import 'package:habit_tracker_app/classes/habit.dart';
import 'package:habit_tracker_app/classes/record.dart';
import 'package:habit_tracker_app/providers/habit_provider.dart';
import 'package:habit_tracker_app/providers/record_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecordCard extends StatefulWidget {
  Record record;
  Habit habit;
  Function deleteRecord;

  RecordCard(this.habit, this.record, this.deleteRecord, {Key? key})
      : super(key: key);

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 3,
      child: GestureDetector(
        onLongPress: () {
          widget.deleteRecord(widget.record, widget.habit.name);
        },
        child: Column(
          children: [
            ListTile(
              title: Text(widget.habit.name),
              subtitle: Text(
                widget.record.startTime,
              ),
              leading: IconButton(
                icon: Icon(IconData(widget.habit.iconCodePoint,
                    fontFamily: widget.habit.iconFontFamily,
                    fontPackage: widget.habit.iconFontPackage)),
                onPressed: () {},
              ),
              iconColor: Color(widget.habit.colorValue),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: 50,
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "Duration: ${widget.record.durationInMinutes} Minutes"),
                    if (widget.record.description.isNotEmpty)
                      Text("Description: ${widget.record.description}"),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
