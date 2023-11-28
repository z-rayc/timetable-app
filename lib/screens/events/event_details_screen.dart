import 'package:flutter/material.dart';
import 'package:timetable_app/models/course_event.dart';
import 'package:timetable_app/models/custom_event.dart';
import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/models/time.dart';
import 'package:timetable_app/widgets/texts/title.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.event});
  final Event event;

  List<Widget> getCourseEvent(BuildContext context, CourseEvent event) {
    return [
      CTitle(event.course.nameAlias ?? event.course.name),
      const SizedBox(height: 10),
      Text("${AppLocalizations.of(context)!.code}: ${event.course.id}"),
      Text("${AppLocalizations.of(context)!.type}: ${event.teachingSummary}"),
      Text("${AppLocalizations.of(context)!.staff}: "),
      for (var staff in event.staff) Text("• ${staff.shortname}"),
      const SizedBox(height: 30),
      Text(
          "${AppLocalizations.of(context)!.location}: ${event.location.roomName}, ${event.location.buildingName}"),
      Row(
        children: [
          Text("${AppLocalizations.of(context)!.link}: "),
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
      Text(
          "${AppLocalizations.of(context)!.date}: ${Time(event.startTime).dayMonthYear}"),
      Text(
          "${AppLocalizations.of(context)!.start}: ${Time(event.startTime).hourMinutes}"),
      Text(
          "${AppLocalizations.of(context)!.end}: ${Time(event.endTime).hourMinutes}"),
    ];
  }

  List<Widget> getCustomEvent(BuildContext context, CustomEvent event) {
    return [
      CTitle(event.name),
      const SizedBox(height: 10),
      Text(
          "${AppLocalizations.of(context)!.description}: ${event.description}"),
      if (event.location != null &&
          event.location!.roomName.isNotEmpty &&
          event.location!.buildingName.isNotEmpty)
        const SizedBox(height: 30),
      if (event.location != null &&
          event.location!.roomName.isNotEmpty &&
          event.location!.buildingName.isNotEmpty)
        Text(
            "${AppLocalizations.of(context)!.location}: ${event.location!.roomName}, ${event.location!.buildingName}"),
      if (event.location != null)
        Row(
          children: [
            Text("${AppLocalizations.of(context)!.link}: "),
            Flexible(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: Colors.lightBlue,
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
      Text(
          "${AppLocalizations.of(context)!.date}: ${Time(event.startTime).dayMonthYear}"),
      Text(
          "${AppLocalizations.of(context)!.start}: ${Time(event.startTime).hourMinutes}"),
      Text(
          "${AppLocalizations.of(context)!.end}: ${Time(event.endTime).hourMinutes}"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    late List<Widget> content;

    // Check type of event
    if (event is CourseEvent) {
      content = getCourseEvent(context, event as CourseEvent);
    } else if (event is CustomEvent) {
      content = getCustomEvent(context, event as CustomEvent);
    } else {
      content = [const Text("Error: Unknown event type")];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.eventDetails),
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
