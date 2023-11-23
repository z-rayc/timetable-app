import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/providers/selected_day_provider.dart';

class DailyTimetable {
  Map<CourseEvent, Color> courseEvents = {};
  DailyTimetable({
    required this.courseEvents,
  });

  DailyTimetable copyWith({
    Map<CourseEvent, Color>? courseEvents,
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
    final db = kSupabase.rest;
    final selectedDay = ref.watch(dateSelectedProvider);
    List<Map<String, dynamic>> courses =
        await db.from('UserCourses').select('*');
    List<String> courseIds = [];
    for (var course in courses) {
      courseIds.add(course['course_id']);
    }

    // Get the course events for the selected day
    // and then map each to a UserCourse color
    Map<CourseEvent, Color> eventsWithColor = {};
    List<CourseEvent> events = await convertToCourseEvents(
        getCourseEventsForDay(selectedDay.date, courseIds));
    for (var event in events) {
      try {
        eventsWithColor[event] = Color(int.parse(courses.firstWhere(
            (course) => course['course_id'] == event.course.id)['color']));
      } catch (_) {
        eventsWithColor[event] = Colors.grey;
        log("Error. Color could not be parsed correctly for event with ID: ${event.id}");
      }
    }

    return DailyTimetable(courseEvents: eventsWithColor);
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
  // setting end of day to 54 days from now to test
  DateTime endOfDay = startOfDay.add(const Duration(days: 1));
  final db = kSupabase.rest;
  final response = await db
      .from('CourseEvents')
      .select<PostgrestList>(
          '*, Course!courseId(*), Staff!staffid(*), Room!roomid(*)')
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
      CourseEvent.fromJson(event),
    );
  }

  return courseEvents;
}
