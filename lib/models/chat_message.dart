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
