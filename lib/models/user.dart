import 'course.dart';

class User {
  const User(this.id, this.username, this.email, this.courses);

  final String id;
  final String username;
  final String email;
  final List<Course> courses;
}
