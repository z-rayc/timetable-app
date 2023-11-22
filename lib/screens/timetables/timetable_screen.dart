import 'package:flutter/material.dart';
import 'package:timetable_app/screens/timetables/single_day_timetable.dart';
import 'package:timetable_app/screens/timetables/week_timetable.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().add(const Duration(days: -365)),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 600;
    return Column(
      children: [
        _datepicker(context),
        !isWide ? const SingleDayTimetable() : const WeekTimeTable(),
      ],
    );
  }

  Widget _datepicker(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select date'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => setState(() =>
                  selectedDate = selectedDate.add(const Duration(days: -1))),
              child: const Text('Yesterday'),
            ),
            TextButton(
              onPressed: () => setState(() => selectedDate = DateTime.now()),
              child: const Text('Today'),
            ),
            TextButton(
              onPressed: () => setState(() =>
                  selectedDate = selectedDate.add(const Duration(days: 1))),
              child: const Text('Tomorrow'),
            ),
          ],
        ),
      ],
    );
  }
}
