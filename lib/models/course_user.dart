import 'package:flutter/material.dart';
import 'package:timetable_app/models/course.dart';

class CourseUser {
  const CourseUser({
    required this.id,
    required this.createdAt,
    required this.course,
    required this.color,
  });

  final String id;
  final DateTime createdAt;
  final Course course;
  final Color color;

  static CourseUser fromJson(Map<String, dynamic> json) {
    return CourseUser(
      id: json['id'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      course: Course.fromJson(json['Course']),
      color: Color(json['color']) ?? Colors.grey,
    );
  }
}
