import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timetable_app/helpers/database_helper.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode ? 1 : 0,
      'isNotificationsEnabled': isNotificationsEnabled ? 1 : 0,
      'language': language.toString(),
    };
  }

  @override
  String toString() {
    return 'AppSettings{isDarkMode: $isDarkMode, isNotificationsEnabled: $isNotificationsEnabled, language: $language}';
  }
}

AppSettings fromMap(Map<dynamic, dynamic> map) {
  print(map);
  return AppSettings(
    isDarkMode: map['isDarkMode'] == 1,
    isNotificationsEnabled: map['isNotificationsEnabled'] == 1,
    language: Language.values
        .firstWhere((element) => element.toString() == map['language']),
  );
}

class AppSettingsNotifier extends AsyncNotifier<AppSettings> {
  DatabaseHelper db = DatabaseHelper.instance;

  // Setter for isDarkMode
  Future<void> setIsDarkMode(bool value) async {
    AppSettings settings = await db.getSettings();
    db.query();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      settings.isDarkMode = value;
      print(settings.isDarkMode);
      await db.updateSetting(settings);
      return settings;
    });
  }

  // Setter for isNotificationsEnabled
  Future<void> setIsNotificationsEnabled(bool value) async {
    AppSettings settings = await db.getSettings();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      settings.isNotificationsEnabled = value;
      print(settings.isNotificationsEnabled);
      await db.updateSetting(settings);
      return settings;
    });
  }

  // Setter for language
  Future<void> setLanguage(Language value) async {
    AppSettings settings = await db.getSettings();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      settings.language = value;
      await db.updateSetting(settings);
      return settings;
    });
  }

  @override
  FutureOr<AppSettings> build() {
    return db.getSettings();
  }
}

final appSettingsProvider =
    AsyncNotifierProvider<AppSettingsNotifier, AppSettings>(() {
  return AppSettingsNotifier();
});
