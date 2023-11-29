/// Model for chat message
class ChatMessage {
  final String id;
  final String chatRoomId;
  final String authorId;
  final String authorNickName;
  final DateTime sentAt;
  final String message;

  const ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.authorId,
    required this.authorNickName,
    required this.sentAt,
    required this.message,
  });

  /// Convert from json to ChatMessage
  static ChatMessage fromJson(dynamic json) {
    return ChatMessage(
      id: json['id'].toString(),
      chatRoomId: json['chat_room_id'].toString(),
      authorId: json['author_id'].toString(),
      authorNickName: json['author_nickname'],
      sentAt: DateTime.parse(json['sent_at']),
      message: json['message'],
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, chatRoomId: $chatRoomId, authorId: $authorId, authorNickName: $authorNickName, sentAt: $sentAt, message: $message)';
  }
}
