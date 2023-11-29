import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/user_course.dart';
import 'package:timetable_app/providers/auth_provider.dart';

class UserCourses {
  UserCourses({required this.userCourses});

  List<UserCourse> userCourses = [];
}

/// A notifier that fetches the user's courses from the database
/// and converts them to [UserCourse] objects.
class MyCoursesNotifier extends AsyncNotifier<UserCourses> {
  @override
  FutureOr<UserCourses> build() async {
    ref.watch(authProvider);
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
