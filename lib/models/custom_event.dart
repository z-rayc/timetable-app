import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/models/location.dart';

class CustomEvent extends Event {
  const CustomEvent({
    required super.id, // Is actually a number in the database
    required super.startTime,
    required super.endTime,
    required this.name,
    required this.description,
    required this.creatorId,
    this.location,
  });

  final String name;
  final String description;
  final String creatorId;
  final Location? location;

  static CustomEvent fromJson(dynamic json) {
    return CustomEvent(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      creatorId: (json['creator']),
      // location: Location.fromJson(json['location']), // TODO: Add back
    );
  }
}

class PartialCustomEvent {
  const PartialCustomEvent({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
    required this.location,
    required this.creatorId,
    required this.inviteeEmails,
  });

  final DateTime startTime;
  final DateTime endTime;
  final String title;
  final String description;
  final Location? location;
  final String creatorId;
  final List<String> inviteeEmails;
}
