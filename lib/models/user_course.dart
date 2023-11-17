import 'package:flutter/material.dart';
import 'package:timetable_app/models/course.dart';

class UserCourse {
  const UserCourse({
    required this.id,
    required this.createdAt,
    required this.course,
    required this.color,
  });

  final String id;
  final DateTime createdAt;
  final Course course;
  final Color color;

  static UserCourse fromJson(Map<String, dynamic> json) {
    return UserCourse(
      id: json['id'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      course: Course.fromJson(json['Course']),
      color: Color(json['color']) ?? Colors.grey,
    );
  }
}
