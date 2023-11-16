import 'package:flutter/material.dart';
import 'package:timetable_app/screens/single_day_timetable.dart';
import 'package:timetable_app/screens/week_timetable.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 600;
    return !isWide
        ? const SingleDayTimetable()
        : const WeekTimeTable();
  }
}
