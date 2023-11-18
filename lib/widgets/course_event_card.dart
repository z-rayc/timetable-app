import 'package:flutter/material.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/screens/event_details_screen.dart';

class CourseEventClass extends StatelessWidget {
  const CourseEventClass({super.key, required this.event});

  final CourseEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: event.course.colour,
      margin: const EdgeInsets.fromLTRB(40, 8, 40, 2),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventDetailsScreen(
              event: event,
            ),
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: event.course.colour,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: event.course.colour,
              title: Text(event.course.name),
              subtitle: Text(event.course.id),
              trailing: hourMinute(event.startTime, event.endTime),
            ),
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
