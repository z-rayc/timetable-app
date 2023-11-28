import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';

final sp = kSupabase.rest;

// Language enum with short names
enum Language {
  english,
  norwegian,
}

extension LanguageExtension on Language {
  String get shortName {
    switch (this) {
      case Language.english:
        return 'en';
      case Language.norwegian:
        return 'nb';
    }
  }
}

class AppSettings {
  Language language;

  AppSettings({
    required this.language,
  });

  AppSettings copyWith({
    Language? language,
  }) {
    return AppSettings(
      language: language ?? this.language,
    );
  }
}

Future<AppSettings> getSettingsFromSupabase() async {
  //if the user does not have a settings row in the database, create one
  final response = await sp.from('Settings').select().single();
  if (await response == null) {
    await sp.from('Settings').insert(
        {'user_id': kSupabase.auth.currentUser!.id, 'Language': 'english'});
  }
  // Fetch settings from Supabase
  // Example code using Supabase to retrieve settings (replace with your implementation)
  final response1 = await sp.from('Settings').select().single();
  final languageValue = response1['Language'] as String;

  // Convert the retrieved language value to the Language enum
  Language language;
  if (languageValue == 'english') {
    language = Language.english;
  } else {
    language = Language.norwegian;
  }

  return AppSettings(
    language: language,
  );
}

class AppSettingsNotifier extends AsyncNotifier<AppSettings> {
  // Setter for language
  Future<void> setLanguage(Language value) async {
    // Update settings in Supabase here (if needed)
    return await sp
        .from('Settings')
        .update({'Language': value.name})
        .eq('user_id', kSupabase.auth.currentUser!.id)
        .select()
        .single();
  }

  @override
  FutureOr<AppSettings> build() {
    return getSettingsFromSupabase();
  }
}

final appSettingsProvider =
    AsyncNotifierProvider<AppSettingsNotifier, AppSettings>(() {
  return AppSettingsNotifier();
});
