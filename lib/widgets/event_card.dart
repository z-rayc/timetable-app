import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/screens/events/event_details_screen.dart';
import 'package:timetable_app/widgets/texts/subtitle.dart';

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
    if (event is CourseEvent) {
      return _CourseEventCard(
        context: context,
        event: event as CourseEvent,
        color: color,
      );
    } else {
      return const Text("Not implemented");
    }
  }
}

class _CourseEventCard extends StatelessWidget {
  const _CourseEventCard({
    required this.context,
    required this.event,
    required this.color,
  });

  final BuildContext context;
  final CourseEvent event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CalendarItemTheme.calendarDecoration(color).copyWith(
        boxShadow: [AppThemes.boxShadow(3.0)],
      ),
      margin: const EdgeInsets.all(3.0),
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
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: 5,
            children: [
              CSubtitle(event.course.nameAlias ?? event.course.name),
              const SizedBox(height: 5),
              Text(event.course.id),
              const SizedBox(width: 10),
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
