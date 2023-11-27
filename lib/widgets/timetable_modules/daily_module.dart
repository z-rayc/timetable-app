import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/widgets/event_card.dart';

class DailyModule extends StatelessWidget {
  const DailyModule({
    super.key,
    required this.days,
    required this.sortedEvents,
    required this.hours,
    required this.showEmptyText,
    required this.eventColours,
  });

  final List<String> days;
  final List<CourseEvent> sortedEvents;
  final List<String> hours;
  final bool showEmptyText;
  final Map<CourseEvent, Color> eventColours;

  @override
  Widget build(BuildContext context) {
    var overlappingEvents = sortedEvents.where((element) {
      var overlapping = false;
      for (var event in sortedEvents) {
        if (event == element) continue;
        if (event.startTime.isBefore(element.endTime) &&
            event.endTime.isAfter(element.startTime)) {
          overlapping = true;
          break;
        }
      }
      return overlapping;
    }).toList();

    bool checkIfOverlapping(CourseEvent event, List<CourseEvent> events) {
      var overlapping = false;
      for (var event2 in events) {
        if (event == event2) {
          overlapping = true;
          break;
        }

        if (event2.startTime.isBefore(event.endTime) &&
            event2.endTime.isAfter(event.startTime)) {
          overlapping = true;
          break;
        }
      }
      return overlapping;
    }

    List<CourseEvent> decideWhichOverlappingEventToMoveToTheRight(
        List<CourseEvent> overlappingEvents) {
      //Check if any of the events are overlapping two or more events
      var doubleOverlappingEvents = overlappingEvents.where((element) {
        var overlapping = false;
        int overlappingCount = 0;
        for (var event in overlappingEvents) {
          if (event == element) continue;
          if (event.startTime.isBefore(element.endTime) &&
              event.endTime.isAfter(element.startTime)) {
            overlappingCount++;
          }
        }
        if (overlappingCount > 1) {
          overlapping = true;
        }

        return overlapping;
      }).toList();

      //Remove the events that are overlapping two or more events from the list
      for (var event in doubleOverlappingEvents) {
        overlappingEvents.remove(event);
      }

      //Check if any of the remaining events are overlapping one event.

      List<CourseEvent> singleOverlappingEvents = [];
      for (var event in overlappingEvents) {
        var overlapping = false;
        for (var event2 in overlappingEvents) {
          if (event == event2) continue;
          if (event2.startTime.isBefore(event.endTime) &&
              event2.endTime.isAfter(event.startTime) &&
              !singleOverlappingEvents.contains(event2)) {
            overlapping = true;
            break;
          }
        }
        if (overlapping) {
          singleOverlappingEvents.add(event);
        }
      }

      //Combine the events that are overlapping one event with the events that are overlapping two or more events
      doubleOverlappingEvents.addAll(singleOverlappingEvents);

      //Remove overlapping events from sortedEvents
      for (var event in doubleOverlappingEvents) {
        sortedEvents.remove(event);
      }

      return doubleOverlappingEvents;
    }

    List<Widget> buildEventWidgets(double topOffset, double leftOffset,
        List<CourseEvent> events, List<CourseEvent> overlappingEvents) {
      List<Widget> eventWidgets = [];
      var calendarEarliest = 7.0;
      for (var event in events) {
        var height = (event.endTime.difference(event.startTime).inMinutes) /
            60 *
            TimeTableTheme.timeTableHourRowHeight;

        eventWidgets.add(
          Positioned(
            top: (event.startTime.hour +
                        (event.startTime.minute / 60) -
                        calendarEarliest) *
                    TimeTableTheme.timeTableHourRowHeight +
                topOffset,
            left: leftOffset,
            child: SizedBox(
              height: (event.endTime.difference(event.startTime).inMinutes) /
                  60 *
                  TimeTableTheme.timeTableHourRowHeight,
              width: (checkIfOverlapping(event, overlappingEvents)
                  ? 135
                  : 270) /* TimeTableTheme.timeTableColumnWidth *
                  (overlappingEvents.isEmpty ? 1 : 2 / 3) */
              ,
              child: EventCard(
                event: event,
                color: eventColours[event]!,
              ),
            ),
          ),
        );
      }
      return eventWidgets;
    }

    List<Widget> generateEventWidgets() {
      var overlapping =
          decideWhichOverlappingEventToMoveToTheRight(overlappingEvents);
      var eventWidgets = buildEventWidgets(25, 0, sortedEvents, overlapping);
      if (overlapping.isNotEmpty) {
        eventWidgets.addAll(buildEventWidgets(
            25,
            135 /* TimeTableTheme.timeTableColumnWidth *
                (overlappingEvents.isEmpty ? 0 : 2 / 3) */
            ,
            overlapping,
            overlapping));
      }

      return eventWidgets;
    }

    if (sortedEvents.isEmpty) {
      return Container(
          margin: const EdgeInsets.only(top: 50),
          width: TimeTableTheme.timeTableColumnWidth,
          child: showEmptyText
              ? const Center(
                  child: Text(
                    'No events today',
                  ),
                )
              : null);
    }
    return SizedBox(
      width: TimeTableTheme.timeTableColumnWidth,
      height: hours.length * TimeTableTheme.timeTableHourRowHeight,
      child: Stack(
        children: generateEventWidgets(),
      ),
    );
  }
}
