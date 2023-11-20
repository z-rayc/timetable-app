import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/models/location.dart';
import 'package:timetable_app/models/user.dart';

class CustomEvent extends Event {
  const CustomEvent({
    required super.id,
    required super.startTime,
    required super.endTime,
    required this.title,
    required this.description,
    required this.location,
    required this.author,
    required this.invitees,
  });

  final String title;
  final String description;
  final Location? location;
  final User author;
  final List<User> invitees;
}

class PartialCustomEvent {
  const PartialCustomEvent({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
    required this.location,
    required this.authorId,
    required this.inviteeEmails,
  });

  final DateTime startTime;
  final DateTime endTime;
  final String title;
  final String description;
  final Location? location;
  final String authorId;
  final List<String> inviteeEmails;
}
