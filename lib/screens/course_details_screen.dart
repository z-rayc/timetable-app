import 'package:flutter/material.dart';
import 'package:timetable_app/models/course.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  final course = const Course(
    id: "IDATA2503",
    name: "Mobile Applications",
    nameAlias: "Mobile Applications",
    colour: Colors.red,
  );

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
        children: <Widget>[
          Text(
            course.name,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                ),
          ),
          Text("Code: ${course.id}"),
          const SizedBox(height: 50),
          Text(
            "Custom",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                ),
          ),
          Text("Alias: ${course.nameAlias}"),
          Row(
            children: [
              Text(
                "Colour: #${course.colour.value.toRadixString(16).substring(2)}",
              ),
              const SizedBox(width: 5),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: course.colour,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
              )
            ],
          ),
          const SizedBox(height: 50),
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
              "Save changes",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
