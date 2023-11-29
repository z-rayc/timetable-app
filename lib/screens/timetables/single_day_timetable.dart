import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/courses_provider.dart';
import 'package:timetable_app/providers/timetable_provider.dart';
import 'package:timetable_app/providers/week_timetable_provider.dart';
import 'package:timetable_app/widgets/event_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SingleDayTimetable extends ConsumerWidget {
  const SingleDayTimetable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var timetable = ref.watch(dailyTimetableProvider);

    return Expanded(
      child: timetable.when(data: (DailyTimetable data) {
        if (data.events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!
                    .noEventsTodayOrNoCoursesAdded),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(myCoursesProvider);
                      ref.invalidate(dailyTimetableProvider);
                      ref.invalidate(weeklyTimetableProvider);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.refreshed)));
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(AppLocalizations.of(context)!.refresh))
              ],
            ),
          );
        } else {
          Iterable<EventCard> cards = data.events.keys.map((key) => EventCard(
                event: key,
                color: data.events[key]!,
              ));

          // sort the cards by start time
          cards = cards.toList()
            ..sort((a, b) => a.event.startTime.compareTo(b.event.startTime));
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: timetable.asData!.value.events.length,
            itemBuilder: (context, index) {
              return cards.elementAt(index);
            },
          );
        }
      }, error: (Object error, StackTrace stackTrace) {
        return SingleChildScrollView(child: Text("Error: $error, $stackTrace"));
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
