class Location {
  const Location({
    required this.roomName,
    required this.buildingName,
    required this.link,
  });

  final String roomName;
  final String buildingName;
  final Uri link;

  static Location fromJson(Map<String, dynamic> json) {
    return Location(
      roomName: json['roomacronym'],
      buildingName: json['buildingname'],
      link: Uri.parse(json['roomurl']),
    );
  }
}
