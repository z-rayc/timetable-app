class ChatMessage {
  final String id;
  final String chatRoomId;
  final String authorId;
  final String authorEmail;
  final String authorName;
  final DateTime sentAt;
  final String message;

  const ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.authorId,
    required this.authorEmail,
    required this.authorName,
    required this.sentAt,
    required this.message,
  });

  static ChatMessage fromJson(dynamic json) {
    return ChatMessage(
      id: json['id'].toString(),
      chatRoomId: json['chat_room_id'].toString(),
      authorId: json['author_id'].toString(),
      authorEmail: json['author_email'],
      authorName: json['author_name'],
      sentAt: DateTime.parse(json['sent_at']),
      message: json['message'],
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, chatRoomId: $chatRoomId, authorId: $authorId, authorEmail: $authorEmail, authorName: $authorName, sentAt: $sentAt, message: $message)';
  }
}

final sampleChatMessage = ChatMessage(
  id: '1',
  chatRoomId: '1',
  authorId: '1',
  authorEmail: 'email@mail.com',
  authorName: 'John Doe',
  sentAt: DateTime(2021, 1, 1, 12, 0),
  message: 'Hello World!',
);
