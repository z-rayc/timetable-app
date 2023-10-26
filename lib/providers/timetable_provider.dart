import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/location.dart';

class DailyTimetable {
  List<CourseEvent> courseEvents = [];

  DailyTimetable({required this.courseEvents});

  DailyTimetable copyWith({
    List<CourseEvent>? courseEvents,
  }) {
    return DailyTimetable(
      courseEvents: courseEvents ?? this.courseEvents,
    );
  }
}

class DailyTimetableNotifier extends StateNotifier<DailyTimetable> {
  DailyTimetableNotifier()
      : super(DailyTimetable(courseEvents: [
          CourseEvent(
              course: const Course(
                  id: "11",
                  name: "Dance Dance Revolution",
                  nameAlias: "DanceRev",
                  colour: Colors.blue),
              staff: ["Bob"],
              location: Location(
                  roomName: "DanceFloor",
                  buildingName: "DiscoHouse",
                  link: Uri(path: "https://ntnu.no")),
              teachingSummary: "Dance, duh",
              id: "11",
              startTime: DateTime(2002),
              endTime: DateTime(2042))
        ]));

  //Setter for courseEvents
  void setCourseEvents(List<CourseEvent> value) {
    final newState = state.copyWith(courseEvents: value);
    state = newState;
  }
}

final dailyTimetableProvider =
    StateNotifierProvider<DailyTimetableNotifier, DailyTimetable>((ref) {
  return DailyTimetableNotifier();
});
