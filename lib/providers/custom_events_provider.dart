import 'dart:async';
import 'dart:developer';

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

    // Get all the events that the user has access to
    /* List<Map<String, dynamic>> events =
        await db.from('CustomEvents').select('*'); */
    List<Map<String, dynamic>> events = await db
        .from('CustomEvents')
        .select('*, CustomEventsMember!event_id(*)');
    // .eq('creator', kSupabase.auth.currentUser!.id);

    return CustomEvents(customEvents: await convertToCustomEvents(events));
  }
}

final customEventsProvider =
    AsyncNotifierProvider<CustomEventsNotifier, CustomEvents>(() {
  return CustomEventsNotifier();
});

Future<List<CustomEvent>> convertToCustomEvents(
    List<Map<String, dynamic>> events) async {
  List<CustomEvent> customEvents = [];

  for (var event in events) {
    log("Event from DB: $event");
    customEvents.add(
      CustomEvent.fromJson(event),
    );
  }

  return customEvents;
}
