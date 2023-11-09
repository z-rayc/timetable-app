import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/time.dart';
import 'package:timetable_app/models/user.dart' as c_user;
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';
import 'package:timetable_app/widgets/texts/label.dart';
import 'package:timetable_app/widgets/texts/subtitle.dart';
import 'package:timetable_app/widgets/texts/title.dart';

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

  /// Validate and submit the form.
  /// Create a new custom event, and add it to the database.
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _setLoading(true);
      // Check that startdate is before enddate
    }
  }

  String _enteredTitle = '';
  String _enteredDescription = '';
  String _enteredRoomName = '';
  String _enteredBuildingName = '';
  List<c_user.User> _enteredInvitees = [];
  DateTime _enteredStartTime = DateTime.now();
  DateTime _enteredEndTime = DateTime.now();

  /// Opens the date picker dialog.
  /// Updates the start time with the selected date if the user selects a date.
  Future<void> _selectStartTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _enteredStartTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _enteredStartTime) {
      setState(() {
        _enteredStartTime = picked;
      });
    }
  }

  /// Opens the date picker dialog.
  /// Updates the end time with the selected date if the user selects a date.
  Future<void> _selectEndTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _enteredStartTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _enteredEndTime) {
      setState(() {
        _enteredEndTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const CTitle('Create custom event'),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CSubtitle('Title'),
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
                  const CSubtitle('Description'),
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
                  const CSubtitle('Start time'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _selectStartTime(context),
                        icon: const Icon(Icons.calendar_today),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            AppThemes.theme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(Time(_enteredStartTime).dayMonthYear)
                    ],
                  ),
                  const SizedBox(height: 20),
                  const CSubtitle('End time'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _selectEndTime(context),
                        icon: const Icon(Icons.calendar_today),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            AppThemes.theme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(Time(_enteredEndTime).dayMonthYear)
                    ],
                  ),
                  const SizedBox(height: 20),
                  const CSubtitle('Room'),
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
                  const CSubtitle('Building'),
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
                  const CSubtitle('Link'),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
