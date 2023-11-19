class ChatRoom {
  final String id;
  final String name;
  final DateTime lastRead;

  ChatRoom({
    required this.id,
    required this.name,
    required this.lastRead,
  });

  static ChatRoom fromJson(dynamic data, {required dynamic lastRead}) {
    return ChatRoom(
      id: data['id'].toString(),
      name: data['name'],
      lastRead: DateTime.parse(lastRead),
    );
  }
}
