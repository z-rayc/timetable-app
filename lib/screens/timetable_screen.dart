import 'package:flutter/material.dart';
import 'package:timetable_app/screens/single_day_timetable.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 600;
    return !isWide
        ? const SingleDayTimetable()
        : const Column(
            // TODO: Add a wide view instead
            children: [
              Text('This is wide view'),
              Expanded(child: SingleDayTimetable()),
            ],
          );
  }
}
