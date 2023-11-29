import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/selected_day_provider.dart';
import 'package:timetable_app/screens/timetables/week_timetable.dart';
import 'package:timetable_app/screens/timetables/single_day_timetable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A screen widget that displays a timetable.
///
/// This widget is responsible for rendering the timetable screen
/// and allows the user to select a date.
class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  /// Opens a date picker dialog and updates the selected date.
  ///
  /// This method is called when the user wants to select a date.
  /// It shows a date picker dialog and updates the selected date
  /// if a new date is chosen.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [ref]: The widget reference.
  ///
  /// Returns: A [Future] that completes when the date selection is done.
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

  /// Builds the timetable screen widget.
  ///
  /// This method is responsible for building the timetable screen widget based on the device's screen width.
  /// If the screen width is greater than 600 pixels, it returns a [WeekViewManager] widget.
  /// Otherwise, it returns a column widget containing a date picker and a [SingleDayTimetable] widget.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [ref]: The widget reference.
  ///
  /// Returns:
  /// The timetable screen widget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isWide = MediaQuery.of(context).size.width > 600;
    if (!isWide) {
      return Column(
        children: [
          _datepicker(context, ref, 1),
          const SingleDayTimetable(),
        ],
      );
    } else {
      return const WeekViewManager();
    }
  }

  /// Builds a date picker widget.
  ///
  /// This widget displays the selected date and provides buttons to navigate
  /// backward and forward in time. It also allows the user to select a new date
  /// by tapping on the displayed date.
  ///
  /// The [context] parameter is the build context.
  /// The [ref] parameter is the widget reference.
  /// The [days] parameter specifies the number of days to navigate backward or forward.
  ///
  /// Returns a [Column] widget containing the date picker UI.
  Widget _datepicker(BuildContext context, WidgetRef ref, int days) {
    final date = ref.watch(dateSelectedProvider).date;
    final startOfYear = DateTime(date.year, 1, 1, 0, 0);
    final firstMonday = startOfYear.weekday;
    final daysInFirstWeek = 8 - firstMonday;
    final diff = date.difference(startOfYear);
    var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
    if (daysInFirstWeek > 3) {
      weeks += 1;
    }

    bool isWide = MediaQuery.of(context).size.width > 600;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _selectDate(context, ref),
              child: Text(
                isWide
                    ? "${AppLocalizations.of(context)!.week} $weeks"
                    : "${ref.watch(dateSelectedProvider).date.day}/${ref.watch(dateSelectedProvider).date.month}/${ref.watch(dateSelectedProvider).date.year}",
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
                  ref.read(dateSelectedProvider.notifier).goBackward(days),
              child: const Icon(Icons.arrow_back),
            ),
            TextButton(
              onPressed: () => ref
                  .read(dateSelectedProvider.notifier)
                  .setDate(DateTime.now()),
              child: Text(AppLocalizations.of(context)!.today),
            ),
            TextButton(
              onPressed: () =>
                  ref.read(dateSelectedProvider.notifier).goForward(days),
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
  }
}
