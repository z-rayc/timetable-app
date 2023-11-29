import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/providers/user_profile_provider.dart';
import 'package:timetable_app/widgets/primary_elevated_button_loading_child.dart';
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';
import 'package:timetable_app/widgets/texts/label.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Part of settings screen. Displays a form to edit the user's nickname.
class UsernameEdit extends ConsumerStatefulWidget {
  const UsernameEdit({super.key});

  @override
  ConsumerState<UsernameEdit> createState() => _UsernameEditState();
}

class _UsernameEditState extends ConsumerState<UsernameEdit> {
  final _key = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  String _enteredUsername = '';

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _submitUsername() async {
    if (_key.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      _key.currentState!.save();

      String currentNickname = ref.read(userProfileProvider).value!.nickname;
      if (currentNickname == _enteredUsername) {
        return;
      }
      try {
        await ref
            .read(userProfileProvider.notifier)
            .setNickname(_enteredUsername);
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.changesSaved)));
        }
      } on UserProfileProviderException catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.nicknameTakenError)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    bool loadingProfile = userProfile.when(
      data: (value) {
        _usernameController.text = value.nickname;
        return false;
      },
      loading: () => true,
      error: (_, __) => false,
    );

    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CLabel(AppLocalizations.of(context)!.nickname),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ShadowedTextFormField(
                  child: TextFormField(
                    enabled: !loadingProfile,
                    controller: _usernameController,
                    decoration: AppThemes.entryFieldTheme,
                    maxLength: 25,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!
                            .pelaseEnterNickname;
                      } else if (value.trim().contains(' ')) {
                        return AppLocalizations.of(context)!
                            .nicknameCannotContainSpaces;
                      } else if (value.trim().length < 3) {
                        return AppLocalizations.of(context)!
                            .nichnameMustBe3Chars;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredUsername = newValue!.trim();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: loadingProfile ? null : _submitUsername,
                child: loadingProfile
                    ? const PrimaryElevatedButtonLoadingChild()
                    : Text(AppLocalizations.of(context)!.save),
              )
            ],
          ),
        ],
      ),
    );
  }
}
