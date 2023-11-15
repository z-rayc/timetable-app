import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/course_user.dart';
import 'package:timetable_app/models/location.dart';

class UserCourses {
  List<CourseUser> courseUsers = [];

  UserCourses({required this.courseUsers});

  UserCourses copyWith({
    List<CourseUser>? courseUser,
  }) {
    return UserCourses(
      courseUsers: courseUser ?? this.courseUsers,
    );
  }

  AsyncValue<UserCourses> toAsyncValue() {
    return AsyncValue.data(this);
  }
}

class MyCoursesNotifier extends AsyncNotifier<UserCourses> {
  @override
  FutureOr<UserCourses> build() async {
    final db = kSupabase.rest;
    List<Map<String, dynamic>> courses =
        await db.from('UserCourses').select('*, Course!course_id(*)');

    return UserCourses(courseUsers: await convertToCourseUserEvents(courses));
  }
}

final myCoursesProvider =
    AsyncNotifierProvider<MyCoursesNotifier, UserCourses>(() {
  return MyCoursesNotifier();
});

Future<List<CourseUser>> convertToCourseUserEvents(
    List<Map<String, dynamic>> events) async {
  List<CourseUser> courseEvents = [];

  for (var event in events) {
    courseEvents.add(
      CourseUser(
          // convert from map<String, dynamic> to Course
          course: Course(
              id: event['Course']['id'],
              name: event['Course']['name'],
              nameAlias: event['Course']['nameAlias'],
              colour: Colors.blue),
          id: event['id'].toString(),
          createdAt: DateTime.parse(event['created_at'])),
    );
  }

  return courseEvents;
}
