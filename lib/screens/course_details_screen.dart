import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/course.dart';
import 'package:timetable_app/models/user_course.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Placeholder course
    final e = UserCourse(
      id: '1',
      color: Colors.red,
      createdAt: DateTime.parse('2021-10-01'),
      course: const Course(
          id: '1', name: 'Mobile Applications', nameAlias: 'Mobile'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Course details"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        children: <Widget>[
          Text(
            e.course.name,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                ),
          ),
          Text("Code: ${e.id}"),
          const SizedBox(height: 50),
          Text(
            "Custom",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                ),
          ),
          Text("Alias: ${e.course.nameAlias}"),
          Row(
            children: [
              Text(
                "Colour: #${e.color.value.toRadixString(16).substring(2)}",
              ),
              const SizedBox(width: 5),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: e.color,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
              )
            ],
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {},
            style: AppThemes.entryButtonTheme,
            child: const Text("Save changes"),
          )
        ],
      ),
    );
  }
}
