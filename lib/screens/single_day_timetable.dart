import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/providers/timetable_provider.dart';

class SingleDayTimetable extends ConsumerWidget {
  const SingleDayTimetable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var timetable = ref.watch(dailyTimetableProvider);

    // Define the timetable start and end times
    const startTime = 8; // 8:00 AM
    const endTime = 18; // 6:00 PM

    // Create a map to group events by course
    final courseEvents = <String, List<CourseEvent>>{};
    for (var event in timetable.courseEvents) {
      if (!courseEvents.containsKey(event.course.name)) {
        courseEvents[event.course.name] = [];
      }
      courseEvents[event.course.name]?.add(event);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Single day timetable'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Create the timetable grid
          Expanded(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('Courses')),
              ],
              rows: [
                // Generate time slots
                for (int hour = startTime; hour <= endTime; hour++) ...[
                  DataRow(
                    cells: [
                      DataCell(Text('$hour:00')),
                      DataCell(
                        SizedBox(
                          height: double.infinity,
                          child: Column(
                            children: [
                              // Generate course blocks for the current hour
                              for (var courseName in courseEvents.keys)
                                if (courseEvents[courseName]!.any((event) =>
                                    event.startTime.hour <= hour &&
                                    event.endTime.hour >= hour))
                                  EventWidget(
                                      courseName: courseName,
                                      color: courseEvents[courseName]![0]
                                          .course
                                          .colour),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventWidget extends StatelessWidget {
  const EventWidget({
    super.key,
    required this.courseName,
    required this.color,
  });

  final String courseName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      // makethe block take up the entire height of the cell
      height: double.infinity,

      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(2.0), color: color),
      child: Text(
        courseName,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
