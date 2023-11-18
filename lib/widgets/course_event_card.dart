import 'package:flutter/material.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/screens/event_details_screen.dart';
import 'package:timetable_app/widgets/texts/subtitle.dart';

class CourseEventClass extends StatelessWidget {
  const CourseEventClass({Key? key, required this.event}) : super(key: key);

  final CourseEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          const Color.fromARGB(255, 255, 166, 196), // TODO: Get proper colour
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
            color: const Color.fromARGB(
                255, 255, 166, 196), // TODO: Get proper colour,
            borderRadius: BorderRadius.circular(10),
          ),
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
