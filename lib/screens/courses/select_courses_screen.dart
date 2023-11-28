import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/providers/courses_provider.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/providers/timetable_provider.dart';
import 'package:timetable_app/providers/week_timetable_provider.dart';

/// Displays the list of courses the user can select from.
/// Allows the user to search for a course by name or ID.
/// User can add or remove a course from their list.
class SelectCoursesScreen extends ConsumerStatefulWidget {
  const SelectCoursesScreen({super.key});

  @override
  ConsumerState<SelectCoursesScreen> createState() {
    return _SelectCoursesScreenState();
  }
}

class _SelectCoursesScreenState extends ConsumerState<SelectCoursesScreen> {
  final TextEditingController programController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  String? selectedProgram;
  String? selectedSemester;

  final List<Course> _allCourses = [];
  final List<Course> _preselectedCourses = [];
  final List<Course> _selectedCourses = [];

  final db = kSupabase.rest;

  List<String> getCoursesAsNames(List<Course> courses) {
    return courses.map((course) => course.name).toList();
  }

  bool listContainsCourseByName(List<Course> courses, String name) {
    return courses.map((course) => course.name).contains(name);
  }

  void saveCourses() {
    addCourses();
    removeCourses();
    // Force refresh data
    ref.invalidate(myCoursesProvider);
    ref.invalidate(dailyTimetableProvider);
    ref.invalidate(weeklyTimetableProvider);
  }

  // Adds all the selected courses to the database
  // If the course already exists in the database, it will be ignored
  void addCourses() async {
    List<Course> coursesToAdd = [];

    // Get the selected and preselected courses' names
    List<String> preselectedCoursesNames =
        getCoursesAsNames(_preselectedCourses);
    List<String> selectedCoursesNames = getCoursesAsNames(_selectedCourses);

    // Only add the selected courses that are not preselected
    for (var course in selectedCoursesNames) {
      if (!preselectedCoursesNames.contains(course)) {
        coursesToAdd.add(
            _selectedCourses.firstWhere((element) => element.name == course));
      }
    }

    // Add the courses to the database
    if (coursesToAdd.isNotEmpty) {
      var courses = coursesToAdd
          .map((course) => {
                'course_id': course.id,
                'color': '0xff9e9e9e', // A default color: grey
                'name_alias': course.name,
              })
          .toList();
      await db
          .from('UserCourses')
          .upsert(
            courses,
            ignoreDuplicates: true,
          )
          .catchError(
        (error) {
          log(error.toString());
        },
      );
    }
  }

  // Remove the courses in the database that
  // have been deselected
  void removeCourses() async {
    var coursesToRemove = [];
    for (var course in _preselectedCourses) {
      if (!_selectedCourses.contains(course)) {
        coursesToRemove.add(course.id);
      }
    }
    await db
        .from('UserCourses')
        .delete()
        .in_('course_id', coursesToRemove)
        .catchError(
      (error) {
        log(error.toString());
      },
    );
  }

  void _addAllCourses() async {
    // Get all courses from the DB and convert them to Course objects
    final List<dynamic> response = await db.from('Course').select('id, name');

    final List<Course> courses =
        response.map((e) => Course.fromJson(e)).toList();
    _allCourses.addAll(courses);
  }

  @override
  void initState() {
    super.initState();
    var myCourses = ref.read(myCoursesProvider);
    var data =
        myCourses.asData?.value.userCourses.map((e) => e.course).toList() ?? [];
    _selectedCourses.addAll(data);
    _preselectedCourses.addAll(data);
    _addAllCourses();
  }

  late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select your courses"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Find a course"),
          const SizedBox(height: 10),
          Autocomplete<Course>(
            displayStringForOption: (Course option) => option.name,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == "") {
                return const Iterable<Course>.empty();
              }
              return _allCourses.where(
                (Course option) {
                  // Search by ID or name
                  // Where the course is not already selected
                  return !listContainsCourseByName(
                          _selectedCourses, option.name) &&
                      !listContainsCourseByName(
                          _preselectedCourses, option.name) &&
                      (option.name
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()) ||
                          option.id
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                },
              );
            },
            fieldViewBuilder: (context, fieldTextEditingController, focusNode,
                onFieldSubmitted) {
              textEditingController = fieldTextEditingController;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    AppThemes.boxShadow(3),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 13,
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  controller: fieldTextEditingController,
                  focusNode: focusNode,
                ),
              );
            },
            onSelected: (Course selection) {
              setState(() {
                _selectedCourses.add(selection);
                textEditingController.clear();
              });
            },
          ),
          const SizedBox(height: 20),
          const Text("Your selected courses"),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                AppThemes.boxShadow(3),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              padding: _selectedCourses.isEmpty
                  ? const EdgeInsets.only(top: 40)
                  : EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _selectedCourses.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(_selectedCourses[index].name),
                trailing: IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _selectedCourses.remove(_selectedCourses[index]);
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              saveCourses();
              popAllScreens(context);
            },
            style: AppThemes.entryButtonTheme,
            child: const Text("Confirm"),
          )
        ],
      ),
    );
  }
}
