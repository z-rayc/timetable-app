class ChatMessage {
  final String id;
  final String chatRoomId;
  final String authorId;
  final String authorEmail;
  final String _authorName;
  final String? _authorNickName;
  final DateTime sentAt;
  final String message;

  const ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.authorId,
    required this.authorEmail,
    required String authorName,
    required String? authorNickName,
    required this.sentAt,
    required this.message,
  })  : _authorNickName = authorNickName,
        _authorName = authorName;

  static ChatMessage fromJson(dynamic json) {
    return ChatMessage(
      id: json['id'].toString(),
      chatRoomId: json['chat_room_id'].toString(),
      authorId: json['author_id'].toString(),
      authorEmail: json['author_email'],
      authorName: json['author_name'],
      authorNickName: json['author_nickname'],
      sentAt: DateTime.parse(json['sent_at']),
      message: json['message'],
    );
  }

  get authorDisplayName {
    if (_authorNickName != null) {
      return _authorNickName;
    } else {
      return _authorName;
    }
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, chatRoomId: $chatRoomId, authorId: $authorId, authorEmail: $authorEmail, authorName: $_authorName, authorNickName: $_authorNickName, sentAt: $sentAt, message: $message)';
  }
}
