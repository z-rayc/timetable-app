import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/providers/timetable_provider.dart';
import 'package:timetable_app/widgets/course_event_card.dart';

class WeekTimeTable extends ConsumerWidget {
  const WeekTimeTable({Key? key}) : super(key: key);

  final double hourItemLength = 100;
  final double dayItemLength = 300;

  Widget horizontalDayItem(String day) {
    return Container(
      width: 300,
      child: Center(
        child: Text(day),
      ),
    );
  }

  Widget verticalHourItem(String hour) {
    return Container(
      height: 100,
      child: Center(
        child: Text(hour),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var timetable = ref.watch(dailyTimetableProvider);

    var days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    var hours = [
      '8:00',
      '9:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00'
    ];

    return timetable.when(data: (DailyTimetable data) {
      var events = timetable.asData!.value.courseEvents;
      var event = events[0];
      return Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: 50,
                width: 50,
              )),
          Positioned(
            top: 45,
            left: 15,
            child: SizedBox(
              width: dayItemLength * days.length,
              height: hourItemLength * hours.length,
              child: InteractiveViewer(
                constrained: false,
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: Column(
                        children: [CourseEventClass(event: event)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            child: Container(
              width: 50,
              color: Colors.red,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  for (var hour in hours) verticalHourItem(hour),
                ],
              ),
            ),
          ),
          Positioned(
            left: 50,
            child: Container(
              height: 50,
              color: Colors.green,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  for (var day in days) horizontalDayItem(day),
                ],
              ),
            ),
          )
        ],
      );
    }, error: (Object error, StackTrace stackTrace) {
      return SingleChildScrollView(child: Text("Error: $error, $stackTrace"));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}
