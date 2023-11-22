import 'package:flutter/material.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/user_course.dart';
import 'package:timetable_app/widgets/texts/title.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({
    super.key,
    required this.uc,
  });

  final UserCourse uc;

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
          CTitle(uc.course.name),
          const SizedBox(height: 5),
          Text("Code: ${uc.course.id}"),
          const SizedBox(height: 50),
          const CTitle("Custom"),
          const SizedBox(height: 5),
          Text("Alias: ${uc.course.nameAlias}"),
          Row(
            children: [
              Text(
                "Color: #${uc.color.value.toRadixString(16).substring(2)}",
              ),
              const SizedBox(width: 5),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: uc.color,
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
