import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/custom_event.dart';

class CustomEvents {
  CustomEvents({required this.customEvents});

  List<CustomEvent> customEvents = [];
}

class CustomEventsNotifier extends AsyncNotifier<CustomEvents> {
  @override
  FutureOr<CustomEvents> build() async {
    final db = kSupabase.rest;

    // Get all the IDs of events that the user has access to.
    List<Map<String, dynamic>> eventsWithAccess =
        await db.from('CustomEventsMember').select('*');
    List<int> eventIdsList = [];
    for (var event in eventsWithAccess) {
      eventIdsList.add(event['event_id']);
    }

    // Get all the events that the user has access to.
    List<dynamic> events =
        await db.from('CustomEvents').select('*').in_('id', eventIdsList);

    return CustomEvents(customEvents: await convertToCustomEvents(events));
  }
}

final customEventsProvider =
    AsyncNotifierProvider<CustomEventsNotifier, CustomEvents>(() {
  return CustomEventsNotifier();
});

Future<List<CustomEvent>> convertToCustomEvents(List<dynamic> events) async {
  List<CustomEvent> customEvents = [];

  for (var event in events) {
    customEvents.add(
      CustomEvent.fromJson(event),
    );
  }

  return customEvents;
}
