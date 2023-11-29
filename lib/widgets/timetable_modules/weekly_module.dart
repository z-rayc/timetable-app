import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/widgets/timetable_modules/daily_module.dart';

class WeeklyModule extends StatefulWidget {
  const WeeklyModule({
    super.key,
    required this.days,
    required this.events,
    required this.hours,
    required this.eventColours, required this.earliestTime,
  });

  final List<String> days;
  final List<Event> events;
  final List<String> hours;
  final Map<Event, Color> eventColours;
  final DateTime earliestTime;

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
      width: widget.days.length * TimeTableTheme.timeTableColumnWidth,
      child: Row(
        children: [
          for (var day in eventMap.keys)
            DailyModule(
              days: widget.days,
              sortedEvents: eventMap[day]!,
              hours: widget.hours,
              showEmptyText: false,
              eventColours: widget.eventColours,
              earliestTime: widget.earliestTime,
            )
        ],
      ),
    );
  }
}
