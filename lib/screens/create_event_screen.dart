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
  /// Returns the selected date if the user selects a date.
  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
        builder: (BuildContext context, Widget? child) {
          // We just wrap these environmental changes around the
          // child in this builder so that we can apply the
          // options selected above. In regular usage, this is
          // rarely necessary, because the default values are
          // usually used as-is.
          return Theme(
            data: Theme.of(context).copyWith(
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: true,
                ),
                child: child!,
              ),
            ),
          );
        });

    return selectedTime == null
        ? null
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
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
                        onPressed: () => {
                          showDateTimePicker(context: context).then((value) {
                            if (value != null) {
                              setState(() {
                                _enteredStartTime = value;
                              });
                            }
                          })
                        },
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
                      Text(Time(_enteredStartTime).dayMonthYearHourMinute)
                    ],
                  ),
                  const SizedBox(height: 20),
                  const CSubtitle('End time'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => {
                          showDateTimePicker(context: context).then((value) {
                            if (value != null) {
                              setState(() {
                                _enteredEndTime = value;
                              });
                            }
                          })
                        },
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
                      Text(Time(_enteredEndTime).dayMonthYearHourMinute)
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
