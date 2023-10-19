import 'package:timetable_app/models/course.dart';

class User {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.courses,
  });

  final String id;
  final String username;
  final String email;
  final List<Course> courses;
}
