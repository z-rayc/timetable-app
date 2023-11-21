import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/providers/courses_provider.dart';
import 'package:timetable_app/providers/timetable_provider.dart';
import 'package:timetable_app/widgets/course_event_card.dart';
import 'package:timetable_app/widgets/timetable_modules/daily_module.dart';
import 'package:timetable_app/widgets/timetable_modules/weekly_module.dart';

class WeekTimeTable extends ConsumerStatefulWidget {
  const WeekTimeTable({super.key, required this.tableDate});
final DateTime tableDate;

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

  ScrollController getHorizontalTableController() {
    return _horizontalTableController;
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

    return timetable.when(data: (DailyTimetable data) {
      if (data.courseEvents.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No events today or no courses added - Week View"),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(myCoursesProvider);
                    ref.invalidate(dailyTimetableProvider);

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Refreshed")));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh"))
            ],
          ),
        );
      }
      var isHorizontal = MediaQuery.of(context).size.width > 600;

      var weekEvents = timetable.asData!.value.courseEvents;

      var todayEvents = weekEvents
          .where((element) =>
              element.startTime.day == widget.tableDate.day &&
              element.startTime.month == widget.tableDate.month &&
              element.startTime.year == widget.tableDate.year)
          .toList();
      var events = isHorizontal ? weekEvents : todayEvents;
      DateTime earliestTime;
      DateTime latestTime;
      if (events.isEmpty) {
        earliestTime = DateTime(2021, 1, 1, 7, 0);
        latestTime = DateTime(2021, 1, 1, 16, 0);
      } else {
        earliestTime = events
            .reduce((value, element) =>
                value.startTime.isBefore(element.startTime) ? value : element)
            .startTime;
        latestTime = events
            .reduce((value, element) =>
                value.endTime.isAfter(element.endTime) ? value : element)
            .endTime;
      }

      var hours = [
        for (var i = 0; earliestTime.hour + i <= latestTime.hour; i++)
          "${earliestTime.hour + i}:00"
      ];
      //Make a hashmap of events with the Datetime weekday as the key

      var topOffset = isHorizontal ? 50.0 : 0.0;

      return Stack(
        children: [
          Positioned(
            top: topOffset,
            left: 50,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              controller: _verticalTableController,
              child: isHorizontal
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _horizontalTableController,
                      child: WeeklyModule(
                        events: events,
                        hours: hours,
                        days: days,
                      ),
                    )
                  : DailyModule(days: days, events: events, hours: hours),
            ),
          ),
          Positioned(
            top: topOffset,
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
          isHorizontal
              ? Positioned(
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
                )
              : Container(),
        ],
      );
    }, error: (Object error, StackTrace stackTrace) {
      return SingleChildScrollView(child: Text("Error: $error, $stackTrace"));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}
