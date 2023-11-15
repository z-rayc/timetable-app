import 'package:timetable_app/models/course.dart';

class CourseUser {
  const CourseUser({
    required this.id,
    required this.createdAt,
    required this.course,
  });

  final String id;
  final DateTime createdAt;
  final Course course;
}
