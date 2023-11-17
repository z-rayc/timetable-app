import 'package:flutter/material.dart';

class Course {
  const Course({
    required this.id,
    required this.name,
    required this.nameAlias,
    required this.colour,
  });

  final String id;
  final String name;
  final String nameAlias;
  final Color colour;

  static Course fromjson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      nameAlias: json['nameAlias'],
      colour: Colors.blue,
    );
  }
}
