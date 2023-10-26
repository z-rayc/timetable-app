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
  final List<Course> _suggestedCourses = [];
  final List<String> _searchResults = [];
  final List<Course> selectedCourses = [];

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
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        children: <Widget>[
          const Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Program"),
                  Text("Search box"),
                ],
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  Text("Semester"),
                  Text("Search box"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Suggestions"),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _suggestedCourses.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(_suggestedCourses[index].name),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      selectedCourses.add(_suggestedCourses[index]);
                      _suggestedCourses.remove(_suggestedCourses[index]);
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Find a course"),
          const SizedBox(height: 20),
          const Text("Your selected courses"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Next"),
          )
        ],
      ),
    );
  }
}
