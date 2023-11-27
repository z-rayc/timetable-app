class ChatRoom {
  final String id;
  String name;
  final String ownerId;
  final bool isCourseChat;
  final String? courseId;
  final DateTime lastRead;

  ChatRoom({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.isCourseChat,
    required this.courseId,
    required this.lastRead,
  });

  static ChatRoom fromJson(dynamic data, {required dynamic lastRead}) {
    return ChatRoom(
      id: data['id'].toString(),
      name: data['name'],
      ownerId: data['owner'].toString(),
      isCourseChat: data['course_chat'],
      courseId: data['course_id'],
      lastRead: DateTime.parse(lastRead),
    );
  }
}
