import 'package:flutter/material.dart';
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

  static CourseUser fromjson(Map<String, dynamic> json) {
    return CourseUser(
      id: json['id'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      course: Course.fromjson(json['Course']),
    );
  }
}
