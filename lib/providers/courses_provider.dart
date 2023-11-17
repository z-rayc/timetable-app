import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/user_course.dart';

class UserCourses {
  List<UserCourse> userCourses = [];

  UserCourses({required this.userCourses});

  UserCourses copyWith({
    List<UserCourse>? courses,
  }) {
    return UserCourses(
      userCourses: courses ?? userCourses,
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

    return UserCourses(userCourses: await convertToUserCourseEvents(courses));
  }
}

final myCoursesProvider =
    AsyncNotifierProvider<MyCoursesNotifier, UserCourses>(() {
  return MyCoursesNotifier();
});

Future<List<UserCourse>> convertToUserCourseEvents(
    List<Map<String, dynamic>> events) async {
  List<UserCourse> courseEvents = [];

  for (var event in events) {
    courseEvents.add(
      UserCourse.fromJson(event),
    );
  }

  return courseEvents;
}
