import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/screens/event_details_screen.dart';
import 'package:timetable_app/widgets/texts/subtitle.dart';

class CourseEventClass extends StatelessWidget {
  const CourseEventClass({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    if (event is CourseEvent) {
      return _CourseEventCard(context: context, event: event as CourseEvent);
    } else {
      return const Text("Not implemented");
    }
  }
}

class _CourseEventCard extends StatelessWidget {
  const _CourseEventCard({
    required this.context,
    required this.event,
  });

  final BuildContext context;
  final CourseEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CalendarItemTheme.calendarDecoration(
        CalendarItemColour.green,
      ), // TODO: Update with color from course
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventDetailsScreen(
              event: event,
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CSubtitle(event.course.nameAlias),
              const SizedBox(height: 5),
              Text(event.course.id),
              hourMinute(event.startTime, event.endTime),
            ],
          ),
        ),
      ),
    );
  }
}

Text hourMinute(DateTime startTime, DateTime endTime) {
  var startHourWithPadding = startTime.hour.toString().padLeft(2, '0');
  var startMinuteWithPadding = startTime.minute.toString().padLeft(2, '0');

  var endHourWithPadding = endTime.hour.toString().padLeft(2, '0');
  var endMinuteWithPadding = endTime.minute.toString().padLeft(2, '0');
  return Text(
      "$startHourWithPadding:$startMinuteWithPadding - $endHourWithPadding:$endMinuteWithPadding");
}
