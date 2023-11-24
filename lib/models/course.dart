class Course {
  Course({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
  String? nameAlias;

  static Course fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
    );
  }

  void setNameAlias(String nameAlias) {
    this.nameAlias = nameAlias;
  }

  @override
  toString() {
    return name;
  }
}
