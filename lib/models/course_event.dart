import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/models/location.dart';
import 'event.dart';

class CourseEvent extends Event {
  const CourseEvent({
    required this.course,
    required this.staff,
    required this.location,
    required this.teachingSummary,
    required super.id,
    required super.startTime,
    required super.endTime,
  });

  final Course course;
  final List<String> staff;
  final Location location;
  final String teachingSummary;
}
