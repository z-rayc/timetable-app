class ChatRoom {
  final String id;
  final String name;

  const ChatRoom({
    required this.id,
    required this.name,
  });

  static ChatRoom fromJson(dynamic data) {
    return ChatRoom(
      id: data['id'].toString(),
      name: data['name'],
    );
  }
}