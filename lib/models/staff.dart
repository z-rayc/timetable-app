class Staff {
  final String id;
  final String firstname;
  final String lastname;
  final String shortname;
  final Uri url;

  const Staff({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.shortname,
    required this.url,
  });

  static Staff fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      shortname: json['shortname'],
      url: Uri.parse(json['url']),
    );
  }
}
