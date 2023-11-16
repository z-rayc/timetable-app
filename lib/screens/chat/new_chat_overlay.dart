import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/widgets/chat/email_list_tile.dart';
import 'package:timetable_app/widgets/listview_container.dart';
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';

class NewChatOverlay extends StatefulWidget {
  const NewChatOverlay({super.key});

  @override
  State<NewChatOverlay> createState() => _NewChatOverlayState();
}

class _NewChatOverlayState extends State<NewChatOverlay> {
  final _formKey = GlobalKey<FormState>();
  List<String> _emails = [];
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  String _enteredEmail = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _submitAdd() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _emails.add(_enteredEmail);
      });
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    var addEmailForm = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Invite people to chat with you'),
          ShadowedTextFormField(
            child: TextFormField(
              controller: _emailController,
              decoration: AppThemes.entryFieldTheme.copyWith(
                hintText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@')) {
                  return 'Please enter an email';
                } else if (value == kSupabase.auth.currentUser!.email) {
                  return 'Cannot add yourself';
                } else if (_emails.contains(value)) {
                  return 'Email already added';
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                _enteredEmail = newValue!;
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  _formKey.currentState!.reset();
                  _emailController.clear();
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
              ),
              ElevatedButton.icon(
                style: AppThemes.entryButtonTheme,
                onPressed: _submitAdd,
                icon: const Icon(Icons.add_circle),
                label: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );

    var emailListContainer = Container(
      decoration: AppThemes.listViewContainerDecoration,
      height: min(deviceHeight * 0.3, 300),
      child: _emails.isEmpty
          ? const Center(child: Text('No emails added yet'))
          : ListView(
              children: _emails.map(
                (email) {
                  return EmailListTile(
                    email: email,
                    onTapDelete: () {
                      setState(
                        () {
                          _emails.remove(email);
                        },
                      );
                    },
                  );
                },
              ).toList(),
            ),
    );

    var bottomButtons = Row(
      children: [
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {},
          style: AppThemes.entryButtonTheme,
          child: const Text('Create'),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Chat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                addEmailForm,
                const SizedBox(height: 20),
                emailListContainer,
                const SizedBox(height: 40),
                bottomButtons,
              ],
            ),
          )),
    );
  }
}
