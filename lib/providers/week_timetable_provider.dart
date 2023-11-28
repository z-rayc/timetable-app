import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/providers/custom_events_provider.dart';
import 'package:timetable_app/providers/selected_day_provider.dart';

class WeeklyTimetable {
  Map<Event, Color> events = {};
  WeeklyTimetable({
    required this.events,
  });

  WeeklyTimetable copyWith({
    Map<Event, Color>? events,
  }) {
    return WeeklyTimetable(
      events: events ?? this.events,
    );
  }

  AsyncValue<WeeklyTimetable> toAsyncValue() {
    return AsyncValue.data(this);
  }
}

class WeeklyTimetableNotifier extends AsyncNotifier<WeeklyTimetable> {
  @override
  FutureOr<WeeklyTimetable> build() async {
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
        getCourseEventsForWeek(selectedDay.date, courseIds));

    Map<Event, Color> eventsWithColor = {};
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

    // Get all of a user's custom events for the selected day
    var customEvents = await ref
        .read(customEventsProvider.notifier)
        .getEventsForWeek(selectedDay.date);

    for (var event in customEvents) {
      eventsWithColor[event] = Colors.grey;
    }

    return WeeklyTimetable(events: eventsWithColor);
  }
}

final weeklyTimetableProvider =
    AsyncNotifierProvider<WeeklyTimetableNotifier, WeeklyTimetable>(() {
  return WeeklyTimetableNotifier();
});

Future<List<Map<String, dynamic>>> getCourseEventsForWeek(
    DateTime day, List courses) async {
  DateTime now = day;
  //Get which day of week it is
  int dayOfWeek = now.weekday;
  //Start of day is monday of the current week
  DateTime startOfDay = now.subtract(Duration(days: dayOfWeek - 1));
  //End day is sunday of the current week
  DateTime endOfDay = now.add(Duration(days: 7 - dayOfWeek));

  // set the time to 00:00:00
  startOfDay = DateTime(startOfDay.year, startOfDay.month, startOfDay.day);
  // set the time to 23:59:59
  endOfDay = DateTime(endOfDay.year, endOfDay.month, endOfDay.day, 23, 59);

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
