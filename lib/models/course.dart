class Course {
  const Course({
    required this.id,
    required this.name,
    required this.nameAlias,
  });

  final String id;
  final String name;
  final String nameAlias;

  static Course fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      nameAlias: json['nameAlias'], // TODO: Move this to UserCourse
    );
  }

  @override
  toString() {
    return name;
  }
}
