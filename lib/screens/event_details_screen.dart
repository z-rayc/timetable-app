import 'package:flutter/material.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/custom_event.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/models/time.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[];

    // If CourseEvent
    if (event is CourseEvent) {
      final newEvent = event as CourseEvent;

      content.add(Text(
        newEvent.course.nameAlias ?? newEvent.course.name,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.black),
      ));
      content.add(Text("Code: ${newEvent.course.id}"));
      content.add(const Text("Staff: "));
      for (var staff in newEvent.staff) {
        content.add(Text("• ${staff.shortname}"));
      }
      content.add(Text(
          "Location: ${newEvent.location.roomName}, ${newEvent.location.buildingName}"));
      content.add(Row(
        children: [
          const Text("Link: "),
          Flexible(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.blue,
              child: Text(
                style: const TextStyle(
                  color: Colors.blue,
                ),
                overflow: TextOverflow.ellipsis,
                "${newEvent.location.link}",
              ),
              onTap: () => launchUrl(newEvent.location.link),
            ),
          )
        ],
      ));
      content.add(const SizedBox(height: 30));
      content.add(Text("Type: ${newEvent.teachingSummary}"));
      content.add(const SizedBox(height: 30));
      content.add(Text("Date: ${Time(newEvent.startTime).dayMonthYear}"));
      content.add(Text("Start: ${Time(newEvent.startTime).hourMinutes}"));
      content.add(Text("End: ${Time(newEvent.endTime).hourMinutes}"));
    }
    // If CustomEvent
    else if (event is CustomEvent) {
      final newEvent = event as CustomEvent;

      content.add(Text(
        newEvent.title,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.black),
      ));
      content.add(Text("Description: ${newEvent.description}"));
      content.add(Text("Author: ${newEvent.author.username}"));
      if (newEvent.location != null) {
        content.add(Text(
            "Location: ${newEvent.location!.roomName}, ${newEvent.location!.buildingName}"));
      }
      content.add(const SizedBox(height: 30));
      content.add(Text("Date: ${Time(newEvent.startTime).dayMonthYear}"));
      content.add(Text("Start: ${Time(newEvent.startTime).hourMinutes}"));
      content.add(Text("End: ${Time(newEvent.endTime).hourMinutes}"));
    }

    // If unknown event type
    else {
      content.add(const Text("Error: Unknown event type"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event details"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        children: content,
      ),
    );
  }
}
