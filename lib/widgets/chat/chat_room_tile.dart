import 'package:flutter/material.dart';
import 'package:timetable_app/models/chat_room.dart';

class ChatRoomTile extends StatelessWidget {
  const ChatRoomTile(
      {super.key, required this.chatRoom, this.onTap, this.onLongPress});
  final ChatRoom chatRoom;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: const CircleAvatar(
          child: Icon(Icons.chat),
        ),
        title: Text(chatRoom.name),
        subtitle: const Text('Last message'),
      ),
    );
  }
}
