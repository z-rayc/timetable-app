import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timetable_app/models/course.dart';

class UserCourse {
  const UserCourse({
    required this.id,
    required this.createdAt,
    required this.course,
    required this.nameAlias,
    required this.color,
  });

  final String id; // This is the course ID
  final DateTime createdAt;
  final Course course;
  final String nameAlias;
  final Color color;

  static UserCourse fromJson(Map<String, dynamic> json) {
    // Try parsing the color and if it fails, use grey as a fallback
    Color color = Colors.grey;
    try {
      color = Color(int.parse(json['color']));
    } catch (_) {
      color = Colors.grey;
      log("Color parsing error. Course ID: ${json['id']}. Color: ${json['color']}");
    }

    return UserCourse(
      id: json['id'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      course: Course.fromJson(json['Course']),
      nameAlias: json['name_alias'],
      color: color,
    );
  }
}
