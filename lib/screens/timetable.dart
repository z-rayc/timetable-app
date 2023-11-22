import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/providers/courses_provider.dart';
import 'package:timetable_app/providers/timetable_provider.dart';
import 'package:timetable_app/widgets/course_event_card.dart';
import 'package:timetable_app/widgets/timetable_modules/daily_module.dart';
import 'package:timetable_app/widgets/timetable_modules/weekly_module.dart';

//
class TimeTable extends ConsumerStatefulWidget {
  const TimeTable({super.key, required this.tableDate});
  final DateTime tableDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TimeTableState();
  }
}

class _TimeTableState extends ConsumerState<TimeTable> {
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
        width: TimeTableTheme.timeTableColumnWidth,
        child: Center(
          child: Text(day),
        ),
      );
    }

    Widget verticalHourItem(String hour) {
      return Container(
        height: TimeTableTheme.timeTableHourRowHeight,
        child: Center(
          child: Text(hour),
        ),
      );
    }

    int turnTimeToMinutes(DateTime time) {
      return time.hour * 60 + time.minute;
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
      var colourMap = timetable.asData!.value.courseEvents;
      var weekEvents = colourMap.keys.toList();

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
        //Get the earlies and latest hours
        earliestTime = events
            .reduce((event, element) => turnTimeToMinutes(event.startTime) <
                    turnTimeToMinutes(element.startTime)
                ? event
                : element)
            .startTime;
        latestTime = events
            .reduce((event, element) => turnTimeToMinutes(event.endTime) >
                    turnTimeToMinutes(element.endTime)
                ? event
                : element)
            .endTime;
      }

      var hours = [
        for (var i = 0; earliestTime.hour + i <= latestTime.hour; i++)
          "${earliestTime.hour + i}:00"
      ];


      //Make a hashmap of events with the Datetime weekday as the key

      var topOffset =
          isHorizontal ? TimeTableTheme.timeTableSideBarSizes[0] : 0.0;

      return Stack(
        children: [
          Positioned(
            top: topOffset,
            left: TimeTableTheme.timeTableSideBarSizes[1].toDouble(),
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
                        eventColours: colourMap,
                      ),
                    )
                  : DailyModule(
                      days: days,
                      sortedEvents: events,
                      hours: hours,
                      showEmptyText: true,
                      eventColours: colourMap,
                    ),
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
                  left: TimeTableTheme.timeTableSideBarSizes[1],
                  top: 0,
                  right: 0,
                  child: Container(
                    height: TimeTableTheme.timeTableSideBarSizes[0],
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
