import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/providers/auth_provider.dart';

final sp = kSupabase.rest;

/// An enum representing different languages.
enum Language {
  /// English language.
  english,

  /// Norwegian language.
  norwegian,
}

/// Extension methods for the [Language] enum.
extension LanguageExtension on Language {
  /// Gets the short name of the language.
  String get shortName {
    switch (this) {
      case Language.english:
        return 'en';
      case Language.norwegian:
        return 'nb';
    }
  }
}

/// Represents the application settings.
class AppSettings {
  Language language;

  /// Constructs an instance of [AppSettings] with the specified [language].
  AppSettings({
    required this.language,
  });

  /// Creates a new [AppSettings] instance with the specified [language].
  ///
  /// If [language] is not provided, the current language is used.
  AppSettings copyWith({
    Language? language,
  }) {
    return AppSettings(
      language: language ?? this.language,
    );
  }
}

/// Retrieves the application settings from Supabase.
/// If the user is not authenticated, it returns default settings with English language.
/// If the user does not have a settings row in the database, it creates one with English language.
/// Fetches the settings from Supabase and converts the language value to the Language enum.
/// Returns an instance of AppSettings with the retrieved language.
Future<AppSettings> getSettingsFromSupabase() async {
  if (kSupabase.auth.currentUser == null) {
    return AppSettings(
      language: Language.english,
    );
  }

  //if the user does not have a settings row in the database, create one
  final List<dynamic> response = await sp.from('Settings').select();

// check if it is an empty array
  if (response.isEmpty) {
    await sp.from('Settings').insert({
      'user_id': kSupabase.auth.currentUser!.id,
      'Language': 'english'
    }).select();
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

/// A notifier class for managing the application settings.
/// Extends [AsyncNotifier] and provides methods for setting the language and retrieving the settings from Supabase.
class AppSettingsNotifier extends AsyncNotifier<AppSettings> {
  // Setter for language
  /// Sets the language of the application.
  /// Updates the language setting in Supabase if needed.
  /// Returns a [Future] that completes when the update is finished.
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
    ref.watch(authProvider);
    return getSettingsFromSupabase();
  }
}

/// Provider for the [AppSettingsNotifier] class.
final appSettingsProvider =
    AsyncNotifierProvider<AppSettingsNotifier, AppSettings>(() {
  return AppSettingsNotifier();
});
