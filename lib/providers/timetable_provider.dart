import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/providers/auth_provider.dart';
import 'package:timetable_app/providers/custom_events_provider.dart';
import 'package:timetable_app/providers/selected_day_provider.dart';

class DailyTimetable {
  Map<Event, Color> events = {};
  DailyTimetable({
    required this.events,
  });

  DailyTimetable copyWith({
    Map<Event, Color>? events,
  }) {
    return DailyTimetable(
      events: events ?? this.events,
    );
  }

  AsyncValue<DailyTimetable> toAsyncValue() {
    return AsyncValue.data(this);
  }
}

class DailyTimetableNotifier extends AsyncNotifier<DailyTimetable> {
  @override
  FutureOr<DailyTimetable> build() async {
    ref.watch(authProvider);
    final db = kSupabase.rest;
    final selectedDay = ref.watch(dateSelectedProvider);

    // Get a user's courses and store the course IDs in a list
    List<Map<String, dynamic>> userCourses =
        await db.from('UserCourses').select('*');
    List<String> courseIds = [];
    for (var course in userCourses) {
      courseIds.add(course['course_id']);
    }

    // Get all of a user's course events for the selected day
    List<CourseEvent> courseEvents = await convertToCourseEvents(
        getCourseEventsForDay(selectedDay.date, courseIds));

    Map<Event, Color> eventsWithColor = {};

    // Add the couse events (classes) to the events map
    for (var event in courseEvents) {
      // Add the name alias to the course
      event.course.setNameAlias(userCourses.firstWhere(
          (course) => course['course_id'] == event.course.id)['name_alias']);
      try {
        // Add the color to the event
        eventsWithColor[event] = Color(int.parse(userCourses.firstWhere(
            (course) => course['course_id'] == event.course.id)['color']));
      } catch (_) {
        // If the color is invalid, set it to grey
        eventsWithColor[event] = Colors.grey;
        log("Color parsing error. Event ID: ${event.id}. Color: ${userCourses.firstWhere((course) => course['course_id'] == event.course.id)['color']}");
      }
    }

    var customEvents = await ref
        .read(customEventsProvider.notifier)
        .getEventsForDay(selectedDay.date);

    for (var event in customEvents) {
      eventsWithColor[event] = Colors.grey;
    }

    return DailyTimetable(events: eventsWithColor);
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
      .from('CourseEvents')
      .select<PostgrestList>(
          '*, Course!courseId(*), Staff!staffid(*), Room!roomid(*)')
      .in_('courseId', courses)
      .gte('start', startOfDay.toIso8601String())
      .lte('start', endOfDay.toIso8601String());

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
