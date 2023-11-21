import 'package:flutter/material.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/widgets/course_event_card.dart';

class WeeklyModule extends StatefulWidget {
  const WeeklyModule({
    super.key,
    required this.days,
    required this.events,
    required this.hours,
  });

  final List<String> days;
  final List<CourseEvent> events;
  final List<String> hours;

  @override
  State<WeeklyModule> createState() => _WeeklyModuleState();
}

class _WeeklyModuleState extends State<WeeklyModule> {
  @override
  Widget build(BuildContext context) {
    var eventMap = {
      for (int date = DateTime.monday; date < DateTime.sunday; date++)
        date: widget.events
            .where((element) => element.startTime.weekday == date)
            .toList()
    };

    return SizedBox(
      width: widget.days.length * 300,
      child: Row(
        children: [
          for (var day in eventMap.keys)
            SizedBox(
              width: 300,
              height: widget.hours.length * 100,
              child: Column(
                children: [
                  for (var event in eventMap[day]!)
                    Container(
                        margin: EdgeInsets.only(
                            top: (event.startTime.hour +
                                        (event.startTime.minute / 60) -
                                        7) *
                                    100 +
                                50),
                        height: (event.endTime
                                .difference(event.startTime)
                                .inMinutes) /
                            60 *
                            100,
                        child: CourseEventClass(event: event)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
