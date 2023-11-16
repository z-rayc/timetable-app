import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/select_courses_screen/form_dropdown_menu.dart';

class SelectCoursesScreen extends StatefulWidget {
  const SelectCoursesScreen({super.key});

  @override
  State<SelectCoursesScreen> createState() {
    return _SelectCoursesScreenState();
  }
}

class _SelectCoursesScreenState extends State<SelectCoursesScreen> {
  final TextEditingController programController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  String? selectedProgram;
  String? selectedSemester;

  final List<DropdownMenuEntry<String>> _semesters = [
    const DropdownMenuEntry(label: "Autumn 2021", value: "H2021"),
    const DropdownMenuEntry(label: "Autumn 2022", value: "H2022"),
    const DropdownMenuEntry(label: "Autumn 2023", value: "H2023"),
  ];

  // These are placeholder courses
  final List<Course> courses = [
    const Course(
      id: "IDATA2503",
      name: "Mobile Applications",
      nameAlias: "Mobile Applications",
      colour: Colors.red,
    ),
    const Course(
      id: "IDATA2504",
      name: "Game Development",
      nameAlias: "Game Development",
      colour: Colors.blue,
    ),
    const Course(
      id: "IDATA2505",
      name: "Web Development",
      nameAlias: "Web Development",
      colour: Colors.green,
    ),
    const Course(
      id: "IDATA2506",
      name: "Data Science",
      nameAlias: "Data Science",
      colour: Colors.yellow,
    ),
  ];
  final List<Course> _suggestedCourses = [];
  final List<Course> _selectedCourses = [];

  @override
  void initState() {
    super.initState();
    _suggestedCourses.addAll(courses);
  }

  late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
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
                    return !_selectedCourses.contains(option) &&
                        option.name
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
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
                replaceNewScreen(context, NavState.timetable);
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
