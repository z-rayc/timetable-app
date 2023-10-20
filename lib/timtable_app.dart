import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/nav_provider.dart';

class TimeTableApp extends ConsumerWidget {
  const TimeTableApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer(
        builder: (context, ref, child) {
          return navState.currentScreen;
        },
      ),
    );
  }
}
