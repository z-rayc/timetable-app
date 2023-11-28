import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/custom_event.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/screens/events/event_details_screen.dart';
import 'package:timetable_app/widgets/texts/label.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.color,
  });

  final Event event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    String title = "[TITLE]";
    // Set title based on event type
    if (event is CourseEvent) {
      CourseEvent newEvent = event as CourseEvent;
      title = newEvent.course.nameAlias ?? newEvent.course.name;
    } else if (event is CustomEvent) {
      CustomEvent newEvent = event as CustomEvent;
      title = newEvent.name;
    }

    const double shadowSize = 3.0;

    return Container(
      decoration: CalendarItemTheme.calendarDecoration(color).copyWith(
        boxShadow: [AppThemes.boxShadow(shadowSize)],
      ),
      margin: const EdgeInsets.all(shadowSize),
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
              CLabel(title),
              const SizedBox(height: 5),
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
    "$startHourWithPadding:$startMinuteWithPadding—$endHourWithPadding:$endMinuteWithPadding",
    style: const TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.8),
      fontSize: 12,
    ),
  );
}
