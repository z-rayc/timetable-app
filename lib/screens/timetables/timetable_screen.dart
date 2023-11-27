import 'package:flutter/material.dart';
import 'package:timetable_app/screens/timetable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/selected_day_provider.dart';
import 'package:timetable_app/screens/timetables/single_day_timetable.dart';
import 'package:timetable_app/widgets/weekly_table.dart';

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
    if (!isWide) {
      return Column(
        children: [
          _datepicker(context, ref),
          const SingleDayTimetable(),
        ],
      );
    } else {
      return const WeekTable();
    }
  }

  Widget _datepicker(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _selectDate(context, ref),
              child: Text(
                "${ref.watch(dateSelectedProvider).date.day}/${ref.watch(dateSelectedProvider).date.month}/${ref.watch(dateSelectedProvider).date.year}",
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () =>
                  ref.read(dateSelectedProvider.notifier).goBackward(),
              child: const Icon(Icons.arrow_back),
            ),
            TextButton(
              onPressed: () => ref
                  .read(dateSelectedProvider.notifier)
                  .setDate(DateTime.now()),
              child: const Text('Today'),
            ),
            TextButton(
              onPressed: () =>
                  ref.read(dateSelectedProvider.notifier).goForward(),
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
    /* !isWide
        ? const SingleDayTimetable()
        : const WeekTimeTable(); */
  }
}
