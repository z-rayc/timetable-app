import 'package:flutter/material.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/widgets/course_event_card.dart';

class DailyModule extends StatelessWidget {
  const DailyModule(
      {super.key,
      required this.days,
      required this.events,
      required this.hours});

  final List<String> days;
  final List<CourseEvent> events;
  final List<String> hours;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 50),
        child: const Center(
          child: Text("Nothing today"),
        ),
      );
    }
    return SizedBox(
      width: 300,
      height: hours.length * 100,
      child: Column(
        children: [
          for (var event in events)
            Container(
                margin: EdgeInsets.only(
                    top: (event.startTime.hour +
                                (event.startTime.minute / 60) -
                                7) *
                            100 +
                        50),
                height: (event.endTime.difference(event.startTime).inMinutes) /
                    60 *
                    100,
                child: CourseEventClass(event: event)),
        ],
      ),
    );
  }
}
