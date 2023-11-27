import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/time.dart';
import 'package:timetable_app/providers/custom_events_provider.dart';
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';
import 'package:timetable_app/widgets/texts/subtitle.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() {
    return _CreateEventScreenState();
  }
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
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
      if (_enteredEndTime.isBefore(_enteredStartTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time.'),
          ),
        );
        _setLoading(false);
      } else {
        _formKey.currentState!.save();

        // Create event with Supabase Edge Function
        _createCustomEvent().then(
          (creationError) => {
            // If error then show dialog, if not then exit screen
            if (context.mounted && creationError != null)
              showErrorDialog(context, creationError.toString())
            else if (context.mounted && creationError == null)
              Navigator.of(context).pop()
          },
        );
      }
      _setLoading(false);
    }
  }

  Future<CustomEventsFetchError?> _createCustomEvent() async {
    return await ref.read(customEventsProvider.notifier).addCustomEvent(
        _enteredName.trim(),
        _enteredDescription.trim(),
        _enteredStartTime,
        _enteredEndTime,
        kSupabase.auth.currentUser!.id,
        _enteredRoomName.trim(),
        _enteredBuildingName.trim(),
        _enteredLink.trim(),
        _enteredInvitees);
  }

  showErrorDialog(BuildContext ctx, String message) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }

  String _enteredName = '';
  String _enteredDescription = '';
  String _enteredRoomName = '';
  String _enteredBuildingName = '';
  String _enteredLink = '';
  final List<String> _enteredInvitees = [];
  DateTime _enteredStartTime = DateTime.now();
  DateTime _enteredEndTime = DateTime.now();

  /// Opens the time picker dialog.
  /// Let's the user select a date and a time.
  /// Returns the selected date and time if the user selected them.
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
      appBar: AppBar(
        title: const Text('Create custom event'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
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
                    onSaved: (newValue) {
                      _enteredName = newValue!;
                    },
                  ),
                ),
                const SizedBox(height: 30),
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
                    onSaved: (newValue) {
                      _enteredDescription = newValue!;
                    },
                  ),
                ),
                const SizedBox(height: 30),
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
                const SizedBox(height: 30),
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
                const SizedBox(height: 30),
                const CSubtitle('Room'),
                const SizedBox(height: 10),
                ShadowedTextFormField(
                  child: TextFormField(
                    decoration: AppThemes.entryFieldTheme.copyWith(
                      hintText: 'Room name',
                    ),
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _enteredRoomName = newValue;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const CSubtitle('Building'),
                const SizedBox(height: 10),
                ShadowedTextFormField(
                  child: TextFormField(
                    decoration: AppThemes.entryFieldTheme.copyWith(
                      hintText: 'Building',
                    ),
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _enteredBuildingName = newValue;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 30),
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
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _enteredLink = newValue;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const CSubtitle('Invitees'),
                const SizedBox(height: 10),
                ShadowedTextFormField(
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: AppThemes.entryFieldTheme.copyWith(
                      hintText: "E-mails separated by commas",
                    ),
                    onSaved: (newValue) {
                      if (newValue != null) {
                        var emails = newValue.split(',');
                        for (var email in emails) {
                          _enteredInvitees.add(email.trim());
                        }
                      }
                    },
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
                        : const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
