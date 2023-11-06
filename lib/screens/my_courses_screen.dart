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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'My courses',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 20),
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
                      decoration: BoxDecoration(
                        color: selectedCourses[index].colour,
                        borderRadius: BorderRadius.circular(5),
                      ),
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
      ),
    );
  }
}
