import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:timetable_app/models/course.dart';

class SelectCoursesScreen extends StatefulWidget {
  const SelectCoursesScreen({super.key});

  @override
  State<SelectCoursesScreen> createState() {
    return _SelectCoursesScreenState();
  }
}

class _SelectCoursesScreenState extends State<SelectCoursesScreen> {
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
  final List<String> _results = [];

  void _handleSearch(String input) {
    _results.clear();
    for (var course in courses) {
      if (course.name.toLowerCase().contains(input.toLowerCase())) {
        setState(() {
          _results.add(course.name);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Info button

    // Program and Semester

    // Suggested courses

    // Find cours manually

    // Your selected courses

    // Next (+ cancel)
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Row(
            children: [
              Column(
                children: [
                  const Text('Program: '),
                  DropdownSearch<Course>(
                    items: courses,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Semester: '),
                  // TODO: Replace with years and fall/spring
                  DropdownSearch<int>(
                    items: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("These might be relevant for you"),
          ListView(
            children: [
              for (var course in courses)
                ListTile(
                  title: Text(course.name),
                  subtitle: Text(course.id),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {},
                  ),
                )
            ],
          ),
          const SizedBox(height: 10),
          const Text("Find a course"),
          TextField(
            onChanged: _handleSearch,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blue,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              hintText: "Search for a course",
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text("Selected courses"),
          ListView(
            children: [
              for (var course in _results)
                ListTile(
                  title: Text(course),
                )
            ],
          )
        ],
      ),
    );
  }
}
