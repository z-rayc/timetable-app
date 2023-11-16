import 'package:flutter/material.dart';
import 'package:timetable_app/models/chat_room.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.chatRoom});
  final ChatRoom chatRoom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatRoom.name),
      ),
      body: const Column(
        
        children: [
          Text('chat'),
        ],
      ),
    );
  }
}
