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

/// Represents a daily timetable with events and their corresponding colors.
class DailyTimetable {
  Map<Event, Color> events = {};

  /// Constructs a [DailyTimetable] with the given [events].
  DailyTimetable({
    required this.events,
  });

  /// Creates a copy of this [DailyTimetable] with optional [events] parameter.
  ///
  /// If [events] is not provided, it defaults to the current [events] of this [DailyTimetable].
  DailyTimetable copyWith({
    Map<Event, Color>? events,
  }) {
    return DailyTimetable(
      events: events ?? this.events,
    );
  }

  /// Converts this [DailyTimetable] to an [AsyncValue] with the data set as this instance.
  AsyncValue<DailyTimetable> toAsyncValue() {
    return AsyncValue.data(this);
  }
}

/// A notifier class for managing the daily timetable.
/// Extends [AsyncNotifier] and provides the implementation for the [build] method.
class DailyTimetableNotifier extends AsyncNotifier<DailyTimetable> {
  @override
  FutureOr<DailyTimetable> build() async {
    // Retrieve the authentication provider
    ref.watch(authProvider);

    // Retrieve the Supabase REST client
    final db = kSupabase.rest;

    // Retrieve the selected day from the dateSelectedProvider
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

    // Map to store events with their corresponding colors
    Map<Event, Color> eventsWithColor = {};

    // Add the course events (classes) to the events map
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

    // Retrieve custom events for the selected day
    var customEvents = await ref
        .read(customEventsProvider.notifier)
        .getEventsForDay(selectedDay.date);

    // Add the custom events to the events map with grey color
    for (var event in customEvents) {
      eventsWithColor[event] = Colors.grey;
    }

    // Return the daily timetable with events and their colors
    return DailyTimetable(events: eventsWithColor);
  }
}

/// A provider for the daily timetable.
///
/// This provider creates an instance of [DailyTimetableNotifier] and provides it as a value.
/// It can be used to access and update the daily timetable data.
final dailyTimetableProvider =
    AsyncNotifierProvider<DailyTimetableNotifier, DailyTimetable>(() {
  return DailyTimetableNotifier();
});

/// Retrieves a list of course events for a specific day.
///
/// The [day] parameter specifies the date for which the course events should be retrieved.
/// The [courses] parameter is a list of course IDs for which the events should be retrieved.
///
/// Returns a Future that resolves to a list of maps, where each map represents a course event.
/// Each map contains information about the course event, including the course ID, staff ID, and room ID.
/// The course, staff, and room information is also included in the map as nested maps.
///
/// Example usage:
/// ```dart
/// DateTime day = DateTime.now();
/// List<String> courses = ['CSE101', 'MATH202'];
/// List<Map<String, dynamic>> courseEvents = await getCourseEventsForDay(day, courses);
/// ```
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

/// Converts a list of maps representing events into a list of [CourseEvent] objects.
///
/// The [events] parameter is a future that resolves to a list of maps, where each map represents an event.
/// Each map should contain the necessary data to create a [CourseEvent] object using the [CourseEvent.fromJson] constructor.
///
/// Returns a future that resolves to a list of [CourseEvent] objects.
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
