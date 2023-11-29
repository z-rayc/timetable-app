import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/user_course.dart';
import 'package:timetable_app/providers/courses_provider.dart';
import 'package:timetable_app/providers/timetable_provider.dart';
import 'package:timetable_app/providers/week_timetable_provider.dart';
import 'package:timetable_app/widgets/color_picker_button.dart';
import 'package:timetable_app/widgets/texts/label.dart';
import 'package:timetable_app/widgets/texts/title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Display the details of a course.
/// Allow the user to change the course's alias and color.
class CourseDetailsScreen extends ConsumerStatefulWidget {
  const CourseDetailsScreen({
    super.key,
    required this.uc,
  });

  final UserCourse uc;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CourseDetailsScreenState();
  }
}

class _CourseDetailsScreenState extends ConsumerState<CourseDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  // The initial values, before initState() is called
  String _enteredAlias = '';
  Color _enteredColor = Colors.grey;
  TextEditingController colorController = TextEditingController();

  void setColor(Color color) {
    setState(() {
      _enteredColor = color;
    });
  }

  @override
  void initState() {
    super.initState();
    _enteredAlias = widget.uc.nameAlias;
    _enteredColor = widget.uc.color;
  }

  @override
  void dispose() {
    colorController.dispose();
    super.dispose();
  }

  // Updates the course's alias and color in the database
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      _setLoading(true);
      try {
        String colorAsString =
            _enteredColor.value.toRadixString(16).padLeft(9, '0x');
        await kSupabase
            .from('UserCourses')
            .update({
              'name_alias': _enteredAlias,
              'color': colorAsString,
            })
            .eq('user_id', kSupabase.auth.currentUser!.id)
            .eq('course_id', widget.uc.course.id)
            .select();
      } on AuthException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
            ),
          );
        }
      } on TimeoutException {
        _showTimeoutSnackbar();
      } finally {
        // Force refresh data
        ref.invalidate(myCoursesProvider);
        ref.invalidate(dailyTimetableProvider);
        ref.invalidate(weeklyTimetableProvider);

        _setLoading(false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.changesSaved),
            ),
          );
        }
      }
    }
  }

  void _showTimeoutSnackbar() {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.requestTimedOut),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.courseDetails),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        children: [
          CTitle(widget.uc.course.name),
          const SizedBox(height: 5),
          Text("${AppLocalizations.of(context)!.code}: ${widget.uc.course.id}"),
          const SizedBox(height: 50),
          CTitle(AppLocalizations.of(context)!.custom),
          const SizedBox(height: 5),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CLabel(
                  AppLocalizations.of(context)!.alias,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _enteredAlias,
                  decoration: AppThemes.entryFieldTheme.copyWith(
                    hintText: AppLocalizations.of(context)!.alias,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.selectAliasError;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredAlias = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                CLabel(
                  AppLocalizations.of(context)!.color,
                ),
                const SizedBox(height: 10),
                ColorPickerButton(
                  initialColor: _enteredColor,
                  setColor: setColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _submitForm,
              style: AppThemes.entryButtonTheme,
              child: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(AppLocalizations.of(context)!.save),
            ),
          ),
        ],
      ),
    );
  }
}
