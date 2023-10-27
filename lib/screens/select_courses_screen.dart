import 'package:flutter/material.dart';
import 'package:timetable_app/app_theme.dart';
import 'package:timetable_app/models/course.dart';
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

  // Dropdown variables
  final List<DropdownMenuEntry<String>> _programs = [
    const DropdownMenuEntry(
      label: "Computer Science (BIDATA)",
      value: "BIDATA",
    ),
    const DropdownMenuEntry(
      label: "Automation and Intelligent Systems",
      value: "BIAIS",
    ),
  ];

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
  final List<String> _searchResults = [];
  final List<Course> _selectedCourses = [];

  @override
  void initState() {
    super.initState();
    _suggestedCourses.addAll(courses);
  }

  void _handleSearch(String input) {
    _searchResults.clear();
    for (var course in courses) {
      if (course.name.toLowerCase().contains(input.toLowerCase())) {
        setState(() {
          _searchResults.add(course.name);
        });
      }
    }
  }

  late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        children: <Widget>[
          SafeArea(child: LayoutBuilder(builder: (ctx, constraints) {
            return Row(
              children: [
                FormDropdownMenu(
                  name: "Program",
                  width: constraints.maxWidth * 0.5 - 5,
                  controller: programController,
                  items: _programs,
                  onSelected: (String? program) {
                    setState(() {
                      selectedProgram = program;
                    });
                  },
                ),
                const Spacer(),
                FormDropdownMenu(
                  name: "Semester",
                  width: constraints.maxWidth * 0.5 - 5,
                  controller: semesterController,
                  items: _semesters,
                  onSelected: (String? semester) {
                    setState(() {
                      selectedSemester = semester;
                    });
                  },
                )
              ],
            );
          })),
          const SizedBox(height: 20),
          const Text("Suggestions"),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                kBoxShadow,
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              padding: _suggestedCourses.isEmpty
                  ? const EdgeInsets.only(top: 50)
                  : EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _suggestedCourses.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(_suggestedCourses[index].name),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _selectedCourses.add(_suggestedCourses[index]);
                      _suggestedCourses.remove(_suggestedCourses[index]);
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Find a course"),
          Autocomplete<Course>(
            displayStringForOption: (Course option) => option.name,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == "") {
                return const Iterable<Course>.empty();
              }
              return courses.where(
                (Course option) {
                  return option.name
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                },
              );
            },
            fieldViewBuilder: (context, fieldTextEditingController, focusNode,
                onFieldSubmitted) {
              textEditingController = fieldTextEditingController;
              return TextField(
                controller: fieldTextEditingController,
                focusNode: focusNode,
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
                kBoxShadow,
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              padding: _selectedCourses.isEmpty
                  ? const EdgeInsets.only(top: 50)
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
            onPressed: () {},
            style: ButtonStyle(
              padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                (Set<MaterialState> states) {
                  return const EdgeInsets.all(5);
                },
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            child: const Text(
              "Next",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
