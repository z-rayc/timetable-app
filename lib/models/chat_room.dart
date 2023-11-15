class ChatRoom {
  final String id;
  final String name;
  final List<String> memberIds;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.memberIds,
  });
}

const sampleChatRoom = ChatRoom(
  id: '1',
  name: 'Sample Chat Room',
  memberIds: ['1', '2'],
);