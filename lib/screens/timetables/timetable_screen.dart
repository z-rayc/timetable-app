import 'package:flutter/material.dart';
import 'package:timetable_app/screens/timetable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/selected_day_provider.dart';
import 'package:timetable_app/screens/timetables/single_day_timetable.dart';

class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: ref.watch(dateSelectedProvider).date,
        firstDate: DateTime.now().add(const Duration(days: -365)),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null && picked != ref.watch(dateSelectedProvider).date) {
      ref.read(dateSelectedProvider.notifier).setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isWide = MediaQuery.of(context).size.width > 600;
    return TimeTable(
      tableDate: DateTime(2023, 11, 22),
    );
    /* !isWide
        ? const SingleDayTimetable()
        : const WeekTimeTable(); */
  }
}
