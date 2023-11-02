import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/providers/timetable_provider.dart';

class SingleDayTimetable extends ConsumerWidget {
  const SingleDayTimetable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var timetable = ref.watch(dailyTimetableProvider);
    // Sort events by start time
    timetable.courseEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event list"),
      ),
      body: ListView.builder(
        itemCount: timetable.courseEvents.length,
        itemBuilder: (context, index) {
          var courseEvent = timetable.courseEvents[index];
          return _buildCourseEventTile(
              courseEvent,
              CalendarItemColour
                  .values[index % CalendarItemColour.values.length]);
        },
      ),
    );
  }
}

Widget _buildCourseEventTile(
    CourseEvent courseEvent, CalendarItemColour colour) {
  return Card(
    color: courseEvent.course.colour,
    margin: const EdgeInsets.fromLTRB(40, 8, 40, 2),
    child: Container(
      decoration: CalendarItemTheme.calendarDecoration(colour),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          tileColor: courseEvent.course.colour,
          title: Text(courseEvent.course.name),
          subtitle: Text(courseEvent.course.id),
          trailing: hourMinute(courseEvent.startTime, courseEvent.endTime),
        ),
      ),
    ),
  );
}

Text hourMinute(DateTime startTime, DateTime endTime) {
  var startHourWithPadding = startTime.hour.toString().padLeft(2, '0');
  var startMinuteWithPadding = startTime.minute.toString().padLeft(2, '0');

  var endHourWithPadding = endTime.hour.toString().padLeft(2, '0');
  var endMinuteWithPadding = endTime.minute.toString().padLeft(2, '0');
  return Text(
      "$startHourWithPadding:$startMinuteWithPadding - $endHourWithPadding:$endMinuteWithPadding");
}
