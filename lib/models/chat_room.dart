class ChatRoom {
  final String id;
  final String name;
  final String ownerId;
  final bool isCourseChat;
  final DateTime lastRead;

  ChatRoom({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.isCourseChat,
    required this.lastRead,
  });

  static ChatRoom fromJson(dynamic data, {required dynamic lastRead}) {
    return ChatRoom(
      id: data['id'].toString(),
      name: data['name'],
      ownerId: data['owner'].toString(),
      isCourseChat: data['course_chat'],
      lastRead: DateTime.parse(lastRead),
    );
  }
}
