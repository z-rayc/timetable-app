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

    return timetable.when(data: (DailyTimetable data) {
      var events = timetable.asData!.value.courseEvents;
      var earliestTime = events
          .reduce((value, element) =>
              value.startTime.isBefore(element.startTime) ? value : element)
          .startTime;
      var latestTime = events
          .reduce((value, element) =>
              value.endTime.isAfter(element.endTime) ? value : element)
          .endTime;

      var hours = [
        for (var i = 0; earliestTime.hour + i <= latestTime.hour; i++)
          "${earliestTime.hour + i}:00"
      ];
      //Make a hashmap of events with the Datetime weekday as the key
      var eventMap = {
        for (int date = DateTime.monday; date < DateTime.sunday; date++)
          date: events
              .where((element) => element.startTime.weekday == date)
              .toList()
      };

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
                child: SizedBox(
                  width: days.length * 300,
                  child: Row(
                    children: [
                      for (var day in eventMap.keys)
                        SizedBox(
                          width: 300,
                          height: hours.length * 100,
                          child: Column(
                            children: [
                              for (var event in eventMap[day]!)
                                Container(
                                    margin: EdgeInsets.only(
                                        top: (event.startTime.hour +
                                                    (event.startTime.minute /
                                                        60) -
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
