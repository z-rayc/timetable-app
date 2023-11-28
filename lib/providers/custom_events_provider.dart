import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/custom_event.dart';
import 'package:timetable_app/providers/auth_provider.dart';

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
      var eventsData = await getCustomEventsForDay(date, eventIds);

      events = convertToCustomEvents(eventsData);
    } catch (e, stack) {
      log("Error getting events for day: ${e.toString()}");
      state = AsyncValue.error(e, stack);
    }

    return events;
  }

  FutureOr<List<CustomEvent>> getEventsForWeek(DateTime date) async {
    state = const AsyncValue.loading();

    List<CustomEvent> events = [];

    try {
      List<int> eventIds = await getEventIdsForUser();
      var eventsData = await getCustomEventsForWeek(date, eventIds);

      events = convertToCustomEvents(eventsData);
    } catch (e, stack) {
      log("Error getting events for week: ${e.toString()}");
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
      log("Error adding event: ${e.toString()}");
      state = AsyncValue.error(e, stack);
    }
    return maybeError;
  }

  @override
  Future<CustomEvents> build() async {
    ref.watch(authProvider);
    final db = kSupabase.rest;

    List<int> eventIds = await getEventIdsForUser();

    // Get all the events that the user has access to.
    List<dynamic> events =
        await db.from('CustomEvents').select('*').in_('id', eventIds);

    return CustomEvents(customEvents: convertToCustomEvents(events));
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

FutureOr<dynamic> getCustomEventsForDay(DateTime day, List eventIds) async {
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

Future<dynamic> getCustomEventsForWeek(DateTime day, List courses) async {
  DateTime now = day;
  //Get which day of week it is
  int dayOfWeek = now.weekday;
  //Start of day is monday of the current week
  DateTime startOfWeek = now.subtract(Duration(days: dayOfWeek - 1));
  //End day is sunday of the current week
  DateTime endOfWeek = now.add(Duration(days: 7 - dayOfWeek));

  // set the time to 00:00:00
  startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  // set the time to 23:59:59
  endOfWeek = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59);

  final db = kSupabase.rest;
  final response = await db
      .from('CustomEvents')
      .select('*')
      .in_('id', courses)
      .gte('start_time', startOfWeek.toIso8601String())
      .lte('start_time', endOfWeek.toIso8601String());

  return response;
}
