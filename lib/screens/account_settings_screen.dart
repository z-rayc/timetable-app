import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/setting_provider.dart';
import 'package:timetable_app/widgets/settings/signout_button.dart';
import 'package:timetable_app/widgets/settings/username_edit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timetable_app/widgets/texts/title.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var settings = ref.watch(appSettingsProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingsTitle),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CTitle(AppLocalizations.of(context)!.appSettings),
              const SizedBox(height: 12),
              settings.when(data: (AppSettings data) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.settingsLanguage),
                          trailing: DropdownButton<Language>(
                            value: settings.asData!.value.language,
                            onChanged: (Language? newValue) {
                              ref
                                  .read(appSettingsProvider.notifier)
                                  .setLanguage(newValue!)
                                  .whenComplete(() {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .languageChanged)));

                                ref.invalidate(appSettingsProvider);
                              });
                            },
                            items: Language.values
                                .map<DropdownMenuItem<Language>>(
                                    (Language value) =>
                                        DropdownMenuItem<Language>(
                                          value: value,
                                          child: Text(value.name),
                                        ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, loading: () {
                return const Center(child: CircularProgressIndicator());
              }, error: (Object error, StackTrace stackTrace) {
                log("Error: $error, $stackTrace");
                return const Center(child: Text("Error loading settingsS"));
              }),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              CTitle(AppLocalizations.of(context)!.accountSettings),
              const SizedBox(height: 12),
              const UsernameEdit(),
              const SignOutButton(),
            ],
          ),
        ));
  }
}
