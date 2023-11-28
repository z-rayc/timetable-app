import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/providers/user_profile_provider.dart';
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';
import 'package:timetable_app/widgets/texts/label.dart';

class UsernameEdit extends ConsumerStatefulWidget {
  const UsernameEdit({super.key});

  @override
  ConsumerState<UsernameEdit> createState() => _UsernameEditState();
}

class _UsernameEditState extends ConsumerState<UsernameEdit> {
  final _key = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  String _enteredUsername = '';
  bool _loading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _submitUsername() async {
    if (_key.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      _key.currentState!.save();
      setState(() {
        _loading = true;
      });
      await ref
          .read(userProfileProvider.notifier)
          .setNickname(_enteredUsername);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    bool loadingProfile = userProfile.when(
      data: (value) {
        _usernameController.text = value.nickname ?? '';
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
          const CLabel('Username'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ShadowedTextFormField(
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: AppThemes.entryFieldTheme,
                    maxLength: 25,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a username';
                      } else if (value.trim().contains(' ')) {
                        return 'Username cannot contain spaces';
                      } else if (value.trim().length < 3) {
                        return 'Username must be at least 3 characters';
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
                onPressed: loadingProfile || _loading ? null : _submitUsername,
                child: const Text('Save'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
