import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/custom_event.dart';

class CustomEventsFetchError {
  final String message;
  CustomEventsFetchError(this.message);
  @override
  String toString() {
    return message;
  }
}

class CustomEvents {
  CustomEvents({required this.customEvents});

  List<CustomEvent> customEvents = [];
}

class CustomEventsNotifier extends AsyncNotifier<CustomEvents> {
  Future<List<int>> getEventIdsForUser() async {
    // Get all the IDs of events that the user has access to.
    List<Map<String, dynamic>> eventsWithAccess =
        await kSupabase.from('CustomEventsMember').select('*');
    List<int> eventIds = [];
    for (var event in eventsWithAccess) {
      eventIds.add(event['event_id']);
    }

    return eventIds;
  }

  FutureOr<List<CustomEvent>> getEventsForDay(DateTime date) async {
    state = const AsyncValue.loading();

    List<CustomEvent> events = [];

    try {
      List<int> eventIds = await getEventIdsForUser();
      List<Map<String, dynamic>> eventsData =
          await getCustomEventsForDay(date, eventIds);

      events = convertToCustomEvents(eventsData);
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
      state = AsyncValue.error(e, stack);
    }

    return events;
  }

  Future<CustomEventsFetchError?> addCustomEvent(
      String name,
      String description,
      DateTime startTime,
      DateTime endTime,
      String creatorId,
      String room,
      String building,
      String link,
      List<String> memberEmails) async {
    CustomEventsFetchError? maybeError;
    state = const AsyncValue.loading();
    try {
      var response =
          await kSupabase.functions.invoke('createCustomEvent', body: {
        'name': name,
        'description': description,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'creatorId': creatorId,
        'room': room,
        'building': building,
        'link': link,
        'memberEmails': memberEmails,
      }).timeout(kDefaultTimeout);

      if (response.status != 201) {
        maybeError = CustomEventsFetchError(response.data['error']);
      }
    } catch (e, stack) {
      log(e.toString());
      state = AsyncValue.error(e, stack);
    }
    return maybeError;
  }

  @override
  Future<CustomEvents> build() async {
    final db = kSupabase.rest;

    List<int> eventIds = await getEventIdsForUser();

    // Get all the events that the user has access to.
    List<dynamic> events =
        await db.from('CustomEvents').select('*').in_('id', eventIds);

    return CustomEvents(customEvents: await convertToCustomEvents(events));
  }
}

final customEventsProvider =
    AsyncNotifierProvider<CustomEventsNotifier, CustomEvents>(() {
  return CustomEventsNotifier();
});

List<CustomEvent> convertToCustomEvents(List<dynamic> events) {
  List<CustomEvent> customEvents = [];

  for (var event in events) {
    customEvents.add(
      CustomEvent.fromJson(event),
    );
  }

  return customEvents;
}

Future<List<Map<String, dynamic>>> getCustomEventsForDay(
    DateTime day, List eventIds) async {
  DateTime now = day;
  DateTime startOfDay = DateTime(now.year, now.month, now.day);
  DateTime endOfDay = startOfDay.add(const Duration(days: 1));
  final db = kSupabase.rest;
  final response = await db
      .from('CustomEvents')
      .select('*')
      .in_('id', eventIds)
      .gte('start_time', startOfDay.toIso8601String())
      .lte('start_time', endOfDay.toIso8601String());

  return response;
}
