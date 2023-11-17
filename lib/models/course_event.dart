import 'package:flutter/material.dart';
import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/models/location.dart';
import 'package:timetable_app/models/staff.dart';
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
  final List<Staff> staff;
  final Location location;
  final String teachingSummary;

  static CourseEvent fromjson(Map<String, dynamic> json) {
    return CourseEvent(
      id: json['id'],
      startTime: DateTime.parse(json['start']),
      endTime: DateTime.parse(json['end']),
      course: Course.fromjson(json['Course']),
      staff: [
        Staff.fromjson(json['Staff']),
      ],
      location: Location.fromjson(json['Room']),
      teachingSummary: json['teaching_summary'] ?? '',
    );
  }
}
