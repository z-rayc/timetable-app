import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/location.dart';
import 'package:timetable_app/models/staff.dart';
import 'package:timetable_app/widgets/event_card.dart';

void main() {
  testWidgets('CourseEventCard displays correct information',
      (WidgetTester tester) async {
    // Create a mock CourseEvent
    final event = CourseEvent(
      course: Course(
        id: 'MATH101',
        name: 'Mathematics',
      ),
      startTime: DateTime(2022, 1, 1, 9, 0),
      endTime: DateTime(2022, 1, 1, 10, 0),
      staff: [
        Staff(
            id: "names nameson",
            firstname: "name",
            lastname: "nameson",
            shortname: "N. Nameson",
            url: Uri.parse("https://www.google.com"))
      ],
      location: Location(
          roomName: "Boulderdash",
          buildingName: "The big one",
          link: Uri.parse("https://www.google.com")),
      id: 'ujkihsdref',
      teachingSummary: 'fesfesf',
    );
    const Color color = Colors.grey;

    // Build the CourseEventCard widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: event,
            color: color,
          ),
        ),
      ),
    );

    // Verify that the correct information is displayed
    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('MATH101'), findsOneWidget);
    expect(find.text('09:00 - 10:00'), findsOneWidget);
  });

  testWidgets('CourseEventCard navigates to EventDetailsScreen when tapped',
      (WidgetTester tester) async {
    // Create a mock CourseEvent
    final event = CourseEvent(
      course: Course(
        id: 'MATH101',
        name: 'Mathematics',
      ),
      startTime: DateTime(2022, 1, 1, 9, 0),
      endTime: DateTime(2022, 1, 1, 10, 0),
      staff: [
        Staff(
            id: "names nameson",
            firstname: "name",
            lastname: "nameson",
            shortname: "N. Nameson",
            url: Uri.parse("https://www.google.com"))
      ],
      location: Location(
          roomName: "Boulderdash",
          buildingName: "The big one",
          link: Uri.parse("https://www.google.com")),
      id: 'ujkihsdref',
      teachingSummary: 'fesfesf',
    );
    const Color color = Colors.grey;

    // Build the CourseEventCard widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: event,
            color: color,
          ),
        ),
      ),
    );

    // Tap the CourseEventCard
    await tester.tap(find.byType(EventCard));

    // Verify that the EventDetailsScreen is displayed
    await tester.pumpAndSettle();
    expect(find.text('Event details'), findsOneWidget);
  });
}
