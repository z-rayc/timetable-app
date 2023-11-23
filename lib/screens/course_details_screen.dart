import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/user_course.dart';
import 'package:timetable_app/widgets/color_picker_button.dart';
import 'package:timetable_app/widgets/texts/label.dart';
import 'package:timetable_app/widgets/texts/title.dart';

/// Displays the details of a course.
/// Allows the user to change the course's alias and color.
class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({
    super.key,
    required this.uc,
  });

  final UserCourse uc;

  @override
  State<StatefulWidget> createState() {
    return _CourseDetailsScreenState();
  }
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  String _enteredAlias = '';
  Color _enteredColor = Colors.grey;
  TextEditingController colorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _enteredAlias = widget.uc.course.nameAlias ?? '';
    _enteredColor = widget.uc.color;
  }

  final db = kSupabase.rest;

  // Updates the course's alias and color in the database
  void _submitForm() {
    String colorAsString = _enteredColor.value.toRadixString(16);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _setLoading(true);

      // Update in database
      db
          .from('UserCourses')
          .update({
            'name_alias': _enteredAlias,
            'color': colorAsString,
          })
          .eq('user_id', kSupabase.auth.currentUser!.id)
          .eq('course_id', widget.uc.course.id)
          .catchError((error) => log(error.toString()));
    }
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course details"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        children: [
          CTitle(widget.uc.course.name),
          const SizedBox(height: 5),
          Text("Code: ${widget.uc.course.id}"),
          const SizedBox(height: 50),
          const CTitle("Custom"),
          const SizedBox(height: 5),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CLabel("Alias"),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _enteredAlias,
                  decoration: AppThemes.entryFieldTheme.copyWith(
                    hintText: 'Alias',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an alias for the course';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredAlias = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                const CLabel("Color"),
                const SizedBox(height: 10),
                ColorPickerButton(_enteredColor),
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
                  : const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}
