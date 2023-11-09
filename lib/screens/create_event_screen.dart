import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/user.dart' as c_user;
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() {
    return _CreateEventScreenState();
  }
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _setLoading(true);
      print("----- Form is valid!");
    }
  }

  String _enteredTitle = '';
  String _enteredDescription = '';
  String _enteredRoomName = '';
  String _enteredBuildingName = '';
  List<c_user.User> _enteredInvitees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Create custom event',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text('Title'),
                  const SizedBox(height: 10),
                  ShadowedTextFormField(
                    child: TextFormField(
                      decoration: AppThemes.entryFieldTheme.copyWith(
                        hintText: 'Title',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Description'),
                  const SizedBox(height: 10),
                  ShadowedTextFormField(
                    child: TextFormField(
                      decoration: AppThemes.entryFieldTheme.copyWith(
                        hintText: 'Description',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Start time'),

                  const SizedBox(height: 20),
                  const Text('End time'),
                  const SizedBox(height: 20),
                  const Text('Room'),
                  const SizedBox(height: 10),
                  ShadowedTextFormField(
                    child: TextFormField(
                      decoration: AppThemes.entryFieldTheme.copyWith(
                        hintText: 'Room name',
                      ),
                      onSaved: (newValue) {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Building'),
                  const SizedBox(height: 10),
                  ShadowedTextFormField(
                    child: TextFormField(
                      decoration: AppThemes.entryFieldTheme.copyWith(
                        hintText: 'Building',
                      ),
                      onSaved: (newValue) {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Link'),
                  const SizedBox(height: 10),
                  ShadowedTextFormField(
                    child: TextFormField(
                      decoration: AppThemes.entryFieldTheme.copyWith(
                        hintText: 'https://use.mazemap.com',
                      ),
                      validator: (value) {
                        var urlPattern =
                            r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
                        var match = RegExp(urlPattern, caseSensitive: false);
                        if (value != null &&
                            value.trim().isNotEmpty &&
                            !match.hasMatch(value)) {
                          return 'Please enter a valid link.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {},
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _loading ? null : _submitForm,
                        style: AppThemes.entryButtonTheme,
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Confirm')),
                  ),
                  // TODO: Add invitees
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
