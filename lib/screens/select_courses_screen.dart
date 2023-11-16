import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/providers/courses_provider.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/select_courses_screen/form_dropdown_menu.dart';

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

  // Placeholder semesters
  final List<DropdownMenuEntry<String>> _semesters = [
    const DropdownMenuEntry(label: "Autumn 2021", value: "H2021"),
    const DropdownMenuEntry(label: "Autumn 2022", value: "H2022"),
    const DropdownMenuEntry(label: "Autumn 2023", value: "H2023"),
  ];

  // These are placeholder courses
  final List<Course> courses = [
    const Course(
      id: "TS500813",
      name: "Menneskelige faktorer",
      nameAlias: "Menneskelige faktorer",
      colour: Colors.red,
    ),
    const Course(
      id: "MUSV1018",
      name: "Hørelære og improvisasjon",
      nameAlias: "Hørelære og improvisasjon",
      colour: Colors.blue,
    ),
    const Course(
      id: "POL3901",
      name: "Masteroppgave i statsvitenskap",
      nameAlias: "Masteroppgave i statsvitenskap",
      colour: Colors.green,
    ),
    const Course(
      id: "LAT1006",
      name: "Latinske oversettelser",
      nameAlias: "Latinske oversettelser",
      colour: Colors.yellow,
    ),
  ];
  final List<Course> _selectedCourses = [];

  final db = kSupabase.rest;

  // Adds all the selected courses to the database
  // If the course already exists in the database, it will be ignored
  void addCourses() async {
    var coursesToAdd = _selectedCourses
        .map((course) => {
              'course_id': course.id,
            })
        .toList();

    db
        .from('UserCourses')
        .upsert(coursesToAdd, ignoreDuplicates: true)
        .catchError(
      (error) {
        log(error);
      },
    );
  }

  // TODO: Remove the courses that
  // have not been selected
  void removeCourses() async {
    // Check which courses are not selected
    // and remove them from the database
  }

  @override
  void initState() {
    super.initState();
  }

  late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    var myCourses = ref.watch(myCoursesProvider);
    // Add the courses that have previously been selected
    _selectedCourses.addAll(
        myCourses.asData?.value.courseUsers.map((e) => e.course).toList() ??
            []);

    print(_selectedCourses);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              return FormDropdownMenu(
                name: "Semester",
                width: constraints.maxWidth,
                controller: semesterController,
                items: _semesters,
                onSelected: (String? semester) {
                  setState(() {
                    selectedSemester = semester;
                  });
                },
              );
            }),
            const SizedBox(height: 20),
            const Text("Find a course"),
            const SizedBox(height: 10),
            Autocomplete<Course>(
              displayStringForOption: (Course option) => option.name,
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == "") {
                  return const Iterable<Course>.empty();
                }
                return courses.where(
                  (Course option) {
                    // Search by ID or name
                    // Where the course is not already selected
                    return !_selectedCourses.contains(option) &&
                        (option.name.toLowerCase().contains(
                                textEditingValue.text.toLowerCase()) ||
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
            const SizedBox(height: 5),
            const Text(
              "Note: You can change these later",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addCourses();
                replaceNewScreen(context, NavState.tabs);
              },
              style: AppThemes.entryButtonTheme,
              child: const Text("Confirm"),
            )
          ],
        ),
      ),
    );
  }
}
