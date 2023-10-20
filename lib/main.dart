import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/timtable_app.dart';

Future<void> main() async {
  await Supabase.initialize(
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ5d3Nsb2JlY2dkamlhY3ZwbW5iIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTc3OTE0MTksImV4cCI6MjAxMzM2NzQxOX0.rdkeFs1rpGQsZUdbGd8AHcRJnF0buxiHi9pA0nvSsOM",
      url: "https://rywslobecgdjiacvpmnb.supabase.co");

  runApp(
    const ProviderScope(
      child: TimeTableApp(),
    ),
  );
}

final kSupabase = Supabase.instance.client;
