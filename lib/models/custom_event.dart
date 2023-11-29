import 'package:timetable_app/models/event.dart';
import 'package:timetable_app/models/location.dart';

/// A custom event is an event that is
/// made by the user.
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
      startTime: DateTime.parse(json['start_time']).toLocal(),
      endTime: DateTime.parse(json['end_time']).toLocal(),
      creatorId: (json['creator']),
      location: Location(
        roomName: json['room'],
        buildingName: json['building'],
        link: Uri.parse(json['link']),
      ),
    );
  }
}
