import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/providers/timetable_provider.dart';
import 'package:timetable_app/screens/event_details_screen.dart';
import 'package:timetable_app/widgets/course_event_card.dart';

class SingleDayTimetable extends ConsumerWidget {
  const SingleDayTimetable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var timetable = ref.watch(dailyTimetableProvider);

    return timetable.when(data: (DailyTimetable data) {
      if (data.courseEvents.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No events today or no courses added"),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: () => ref.invalidate(dailyTimetableProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh"))
            ],
          ),
        );
      } else {
        return Scaffold(
          body: ListView.builder(
            itemCount: timetable.asData!.value.courseEvents.length,
            itemBuilder: (context, index) {
              var courseEvent = timetable.asData!.value.courseEvents[index];
              return CourseEventClass(event: courseEvent);
            },
          ),
        );
      }
    }, error: (Object error, StackTrace stackTrace) {
      return SingleChildScrollView(child: Text("Error: $error, $stackTrace"));
    }, loading: () {
      return const CircularProgressIndicator();
    });
  }
}
