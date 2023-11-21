import 'package:flutter/material.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/widgets/course_event_card.dart';

class DailyModule extends StatelessWidget {
  const DailyModule(
      {super.key,
      required this.days,
      required this.sortedEvents,
      required this.hours,
      required this.showEmptyText});

  final List<String> days;
  final List<CourseEvent> sortedEvents;
  final List<String> hours;
  final bool showEmptyText;

  @override
  Widget build(BuildContext context) {
    List<Widget> generateEventWidgets() {
      List<Widget> eventWidgets = [];
      var lastEndTime = 7.0;
      var extraMargin = 50;

      for (var event in sortedEvents) {
        var difference =
            event.endTime.difference(event.startTime).inMinutes / 60;

        eventWidgets.add(
          Container(
            margin: EdgeInsets.only(
              top: ((event.startTime.hour +
                          (event.startTime.minute / 60) -
                          lastEndTime) *
                      100 +
                  extraMargin),
            ),
            height: (event.endTime.difference(event.startTime).inMinutes) /
                60 *
                100,
            child: CourseEventClass(event: event),
          ),
        );

        lastEndTime = event.endTime.hour + (event.endTime.minute / 60);
        extraMargin = 0;
      }
      return eventWidgets;
    }

    if (sortedEvents.isEmpty) {
      return Container(
          margin: const EdgeInsets.only(top: 50),
          width: 300,
          child: showEmptyText
              ? const Center(
                  child: Text(
                    'No events today',
                  ),
                )
              : null);
    }
    return SizedBox(
      width: 300,
      height: hours.length * 100,
      child: Column(
        children: generateEventWidgets(),
      ),
    );
  }
}
