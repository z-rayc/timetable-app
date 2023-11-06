import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/providers/nav_provider.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() {
    return _MyCoursesScreenState();
  }
}

// Placeholder courses
const selectedCourses = [
  Course(
      id: '1',
      name: 'IDATA2504',
      nameAlias: 'Mobile Applications',
      colour: Colors.red),
  Course(
      id: '2',
      name: 'IDATA2505',
      nameAlias: 'Game Development',
      colour: Colors.blue),
  Course(
      id: '3',
      name: 'IDATA2506',
      nameAlias: 'Web Development',
      colour: Colors.green),
];

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: selectedCourses.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  leading: Container(
                    height: 20,
                    width: 20,
                    color: selectedCourses[index].colour,
                  ),
                  title: Text(selectedCourses[index].nameAlias),
                  subtitle: Text(selectedCourses[index].name),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              pushNewScreen(context, NavState.selectCourses);
            },
            style: AppThemes.entryButtonTheme,
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}