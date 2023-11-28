import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/user_course.dart';
import 'package:timetable_app/providers/courses_provider.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/screens/courses/course_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCoursesScreen extends ConsumerWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var myCourses = ref.watch(myCoursesProvider);

    return myCourses.when(
      data: (UserCourses data) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.myCourses),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (var course in data.userCourses)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: courseTile(course, context),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  pushNewScreen(context, NavState.selectCourses);
                },
                style: AppThemes.entryButtonTheme,
                child: Text(AppLocalizations.of(context)!.edit),
              ),
            ],
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return SingleChildScrollView(
          child: Text("Error: $error, $stackTrace",
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center),
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

ListTile courseTile(UserCourse uc, BuildContext context) {
  return ListTile(
    leading: Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: uc.color,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    title: Text(uc.nameAlias),
    subtitle: Text(uc.course.id),
    trailing: IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CourseDetailsScreen(
            uc: uc,
          ),
        ));
      },
    ),
  );
}
