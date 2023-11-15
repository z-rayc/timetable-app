import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/location.dart';

class DailyTimetable {
  List<CourseEvent> courseEvents = [];

  DailyTimetable({required this.courseEvents});

  DailyTimetable copyWith({
    List<CourseEvent>? courseEvents,
  }) {
    return DailyTimetable(
      courseEvents: courseEvents ?? this.courseEvents,
    );
  }

  AsyncValue<DailyTimetable> toAsyncValue() {
    return AsyncValue.data(this);
  }
}

class DailyTimetableNotifier extends AsyncNotifier<DailyTimetable> {
  @override
  FutureOr<DailyTimetable> build() async {
    return DailyTimetable(
        courseEvents: await convertToCourseEvents(getCourseEventsForDay(
            DateTime.now(), ['IDATA2502', 'IDATA2503', 'IDATA2504'])));
  }
}

final dailyTimetableProvider =
    AsyncNotifierProvider<DailyTimetableNotifier, DailyTimetable>(() {
  return DailyTimetableNotifier();
});

Future<List<Map<String, dynamic>>> getCourseEventsForDay(
    DateTime day, List courses) async {
  DateTime now = day;
  DateTime startOfDay = DateTime(now.year, now.month, now.day);
  DateTime endOfDay = startOfDay.add(const Duration(days: 1));
  final db = kSupabase.rest;
  final response = await db
      .from('Events')
      .select<PostgrestList>('*, Course!courseId(*), Staff!staffid(*)')
      .in_('courseId', courses)
      .gte('start', startOfDay.toIso8601String())
      .lte('end', endOfDay.toIso8601String());

  return response;
}

Future<List<CourseEvent>> convertToCourseEvents(
    Future<List<Map<String, dynamic>>> events) async {
  List<CourseEvent> courseEvents = [];

  for (var event in await events) {
    courseEvents.add(
      CourseEvent(
          // convert from map<String, dynamic> to Course
          course: Course(
              id: event['Course']['id'],
              name: event['Course']['name'],
              nameAlias: event['Course']['nameAlias'],
              colour: Colors.blue),
          startTime: DateTime.parse(event['start']),
          endTime: DateTime.parse(event['end']),
          staff: [event['Staff']['shortname']],
          location: Location(
            roomName: '',
            buildingName: '',
            link: Uri(host: "google.com", scheme: "https"),
          ),
          id: event['id'],
          teachingSummary: 'empty for now'),
    );
  }

  return courseEvents;
}
