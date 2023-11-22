import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/courses_provider.dart';
import 'package:timetable_app/providers/timetable_provider.dart';
import 'package:timetable_app/widgets/event_card.dart';

class SingleDayTimetable extends ConsumerWidget {
  const SingleDayTimetable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var timetable = ref.watch(dailyTimetableProvider);

    return Expanded(
      child: timetable.when(data: (DailyTimetable data) {
        if (data.courseEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No events today or no courses added"),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(myCoursesProvider);
                      ref.invalidate(dailyTimetableProvider);

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Refreshed")));
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh"))
              ],
            ),
          );
        } else {
          // sort events by start time and date (earliest first)
          data.courseEvents.sort((a, b) {
            if (a.startTime.isBefore(b.startTime)) {
              return -1;
            } else if (a.startTime.isAfter(b.startTime)) {
              return 1;
            } else {
              return 0;
            }
          });
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: timetable.asData!.value.courseEvents.length,
            itemBuilder: (context, index) {
              var courseEvent = timetable.asData!.value.courseEvents[index];
              return EventCard(event: courseEvent);
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
