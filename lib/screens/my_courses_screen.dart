import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/models/user_course.dart';
import 'package:timetable_app/providers/courses_provider.dart';
import 'package:timetable_app/providers/nav_provider.dart';

class MyCoursesScreen extends ConsumerWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var myCourses = ref.watch(myCoursesProvider);

    return myCourses.when(
      data: (UserCourses data) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My courses'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: myCourses.asData?.value.userCourses.length ?? 0,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child:
                        courseTile(myCourses.asData!.value.userCourses[index]),
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

ListTile courseTile(UserCourse cu) {
  return ListTile(
    leading: Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: cu.color,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    title: Text(cu.course.id),
    subtitle: Text(cu.course.nameAlias),
  );
}
