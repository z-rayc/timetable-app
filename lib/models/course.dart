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
}
