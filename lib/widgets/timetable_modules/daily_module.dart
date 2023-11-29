import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/widgets/event_card.dart';

/// A module that displays the events for a single day
class DailyModule extends StatelessWidget {
  const DailyModule({
    super.key,
    required this.days,
    required this.sortedEvents,
    required this.hours,
    required this.showEmptyText,
    required this.eventColours,
    required this.earliestTime,
  });

  final List<String> days;
  final List<Event> sortedEvents;
  final List<String> hours;
  final bool showEmptyText;
  final Map<Event, Color> eventColours;
  final DateTime earliestTime;

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

    bool checkIfOverlapping(Event event, List<Event> events) {
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

    /// Decides which overlapping event to move to the right.
    ///
    /// This method takes a list of overlapping events and determines which event(s) should be moved to the right to resolve the overlap.
    /// It first checks if any of the events are overlapping two or more events. If so, it removes those events from the list.
    /// Then, it checks if any of the remaining events are overlapping one event. If so, it adds them to a separate list.
    /// Finally, it combines the events that are overlapping one event with the events that are overlapping two or more events.
    /// It also removes the overlapping events from the `sortedEvents` list.
    ///
    /// Parameters:
    /// - `overlappingEvents`: A list of events that are overlapping.
    ///
    /// Returns:
    /// A list of events that should be moved to the right to resolve the overlap.
    List<Event> decideWhichOverlappingEventToMoveToTheRight(
        List<Event> overlappingEvents) {
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

      List<Event> singleOverlappingEvents = [];
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

    /// Builds a list of event widgets based on the provided parameters.
    ///
    /// The [topOffset] and [leftOffset] specify the positioning of the event widgets.
    /// The [events] list contains the events to be displayed.
    /// The [overlappingEvents] list contains the events that overlap with each other.
    ///
    /// Returns a list of [Widget] objects representing the event widgets.
    List<Widget> buildEventWidgets(double topOffset, double leftOffset,
        List<Event> events, List<Event> overlappingEvents) {
      List<Widget> eventWidgets = [];
      var calendarEarliest = earliestTime.hour;
      for (var event in events) {
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
              width: (checkIfOverlapping(event, overlappingEvents) ? 135 : 270),
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

    /// Generates a list of event widgets based on the provided data.
    ///
    /// This method first determines which overlapping events should be moved to the right
    /// to avoid overlapping on the timetable. Then, it builds event widgets for the sorted
    /// events and adds them to the list. If there are any overlapping events, it also builds
    /// event widgets for those and adds them to the list.
    ///
    /// Returns the list of event widgets.
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
          overlapping,
        ));
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
