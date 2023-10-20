import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/timtable_app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TimeTableApp(),
    ),
  );
}
