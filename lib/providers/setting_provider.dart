import 'package:flutter_riverpod/flutter_riverpod.dart';

//language enum
enum Language {
  english,
  german,
  french,
}

class AppSettings {
  bool isDarkMode;
  bool isNotificationsEnabled;
  Language language;

  AppSettings({
    required this.isDarkMode,
    required this.isNotificationsEnabled,
    required this.language,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? isNotificationsEnabled,
    Language? language,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      language: language ?? this.language,
    );
  }
}

AppSettings getSettingsFromStore() {
  return AppSettings(
    isDarkMode: true,
    isNotificationsEnabled: false,
    language: Language.english,
  );
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(getSettingsFromStore());

  // Setter for isDarkMode
  void setIsDarkMode(bool value) {
    final newState = state.copyWith(isDarkMode: value);
    state = newState;
  }

  // Setter for isNotificationsEnabled
  void setIsNotificationsEnabled(bool value) {
    final newState = state.copyWith(isNotificationsEnabled: value);
    state = newState;
  }

  // Setter for language
  void setLanguage(Language value) {
    final newState = state.copyWith(language: value);
    state = newState;
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});
