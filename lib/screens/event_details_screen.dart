import 'package:flutter/material.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/custom_event.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/models/time.dart';
import 'package:timetable_app/widgets/texts/title.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.event});
  final Event event;

  List<Widget> getCourseEvent(CourseEvent event) {
    return [
      CTitle(event.course.nameAlias ?? event.course.name),
      const SizedBox(height: 10),
      Text("Code: ${event.course.id}"),
      Text("Type: ${event.teachingSummary}"),
      const Text("Staff: "),
      for (var staff in event.staff) Text("• ${staff.shortname}"),
      const SizedBox(height: 30),
      Text(
          "Location: ${event.location.roomName}, ${event.location.buildingName}"),
      Row(
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
                "${event.location.link}",
              ),
              onTap: () => launchUrl(event.location.link),
            ),
          )
        ],
      ),
      const SizedBox(height: 30),
      Text("Date: ${Time(event.startTime).dayMonthYear}"),
      Text("Start: ${Time(event.startTime).hourMinutes}"),
      Text("End: ${Time(event.endTime).hourMinutes}"),
    ];
  }

  List<Widget> getCustomEvent(CustomEvent event) {
    return [
      CTitle(event.title),
      const SizedBox(height: 10),
      Text("Description: ${event.description}"),
      Text("Author: ${event.author.username}"),
      const SizedBox(height: 30),
      if (event.location != null)
        Text(
            "Location: ${event.location!.roomName}, ${event.location!.buildingName}"),
      Row(
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
                "${event.location!.link}",
              ),
              onTap: () => launchUrl(event.location!.link),
            ),
          )
        ],
      ),
      const SizedBox(height: 30),
      Text("Date: ${Time(event.startTime).dayMonthYear}"),
      Text("Start: ${Time(event.startTime).hourMinutes}"),
      Text("End: ${Time(event.endTime).hourMinutes}"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    late List<Widget> content;

    // Check type of event
    if (event is CourseEvent) {
      content = getCourseEvent(event as CourseEvent);
    } else if (event is CustomEvent) {
      content = getCustomEvent(event as CustomEvent);
    } else {
      content = [const Text("Error: Unknown event type")];
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
