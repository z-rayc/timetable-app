import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/providers/timetable_provider.dart';
import 'package:timetable_app/widgets/course_event_card.dart';

class WeekTimeTable extends ConsumerStatefulWidget {
  const WeekTimeTable({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _WeekTimeTableState();
  }
}

class _WeekTimeTableState extends ConsumerState<WeekTimeTable> {
  final double hourItemLength = 100;
  final double dayItemLength = 300;

  late LinkedScrollControllerGroup _horizontalControllers;
  late LinkedScrollControllerGroup _verticalControllers;

  late ScrollController _horizontalDayController;
  late ScrollController _horizontalTableController;
  late ScrollController _verticalHourController;
  late ScrollController _verticalTableController;

  @override
  void initState() {
    _horizontalControllers = LinkedScrollControllerGroup();
    _verticalControllers = LinkedScrollControllerGroup();

    _horizontalDayController = _horizontalControllers.addAndGet();
    _horizontalTableController = _horizontalControllers.addAndGet();

    _verticalHourController = _verticalControllers.addAndGet();
    _verticalTableController = _verticalControllers.addAndGet();

    super.initState();
  }

  @override
  void dispose() {
    _horizontalDayController.dispose();
    _horizontalTableController.dispose();
    _verticalHourController.dispose();
    _verticalTableController.dispose();

    super.dispose();
  }

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
  Widget build(BuildContext context) {
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
      
      //Sort events by start time and date (earliest first)
      events.sort((a, b) {
        if (a.startTime.isBefore(b.startTime)) {
          return -1;
        } else if (a.startTime.isAfter(b.startTime)) {
          return 1;
        } else {
          return 0;
        }
      });
      
      return Stack(
        children: [
          Positioned(
            top: 50,
            left: 50,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              controller: _verticalTableController,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontalTableController,
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      height: hours.length * 100,
                      child: Column(
                        children: [CourseEventClass(event: event)],
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: hours.length * 100,
                      child: Column(
                        children: [CourseEventClass(event: event)],
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: hours.length * 100,
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
            left: 0,
            bottom: 0,
            child: Container(
              width: 50,
              height: hours.length * 100,
              color: Colors.red,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: _verticalHourController,
                shrinkWrap: true,
                children: [
                  for (var hour in hours) verticalHourItem(hour),
                ],
              ),
            ),
          ),
          Positioned(
            left: 50,
            top: 0,
            right: 0,
            child: Container(
              height: 50,
              color: Colors.green,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _horizontalDayController,
                shrinkWrap: true,
                children: [
                  for (var day in days) horizontalDayItem(day),
                ],
              ),
            ),
          ),
        ],
      );
    }, error: (Object error, StackTrace stackTrace) {
      return SingleChildScrollView(child: Text("Error: $error, $stackTrace"));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}
