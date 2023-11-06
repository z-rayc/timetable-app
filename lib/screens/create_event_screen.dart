import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/user.dart';
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

  String _enteredTitle = '';
  String _enteredDescription = '';
  String _enteredRoomName = '';
  String _enteredBuildingName = '';
  List<User> _enteredInvitees = [];

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
                      decoration: AppThemes.entryFieldTheme,
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
                      decoration: AppThemes.entryFieldTheme,
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
                  const Text('Room name'),
                  const SizedBox(height: 10),
                  ShadowedTextFormField(
                    child: TextFormField(
                      decoration: AppThemes.entryFieldTheme,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a room name.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Building'),
                  const SizedBox(height: 10),
                  ShadowedTextFormField(
                    child: TextFormField(
                      decoration: AppThemes.entryFieldTheme,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a building.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Link'),
                  const SizedBox(height: 10),
                  ShadowedTextFormField(
                    child: TextFormField(
                      decoration: AppThemes.entryFieldTheme,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a location link.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {},
                    ),
                  ),
                  // TODO: Add invitees
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Validate and submit form
              },
              style: AppThemes.entryButtonTheme,
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
