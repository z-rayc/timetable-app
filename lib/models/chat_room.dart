class ChatRoom {
  final String id;
  final String name;

  const ChatRoom({
    required this.id,
    required this.name,
  });
}

const sampleChatRoom = ChatRoom(
  id: '1',
  name: 'Sample Chat Room',
);
