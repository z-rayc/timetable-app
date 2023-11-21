import 'package:flutter/material.dart';
import 'package:timetable_app/screens/timetable.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 600;
    return TimeTable(
      tableDate: DateTime(2023, 11, 22),
    );
    /* !isWide
        ? const SingleDayTimetable()
        : const WeekTimeTable(); */
  }
}
