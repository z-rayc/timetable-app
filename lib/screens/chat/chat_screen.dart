import 'package:flutter/material.dart';
import 'package:timetable_app/models/chat_room.dart';
import 'package:timetable_app/widgets/chat/new_chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatRoom});
  final ChatRoom chatRoom;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = TextEditingController();

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoom.name),
      ),
      body: Column(
        children: [
          Text('messages'),
          Spacer(),
          NewChatMessage(
            chatRoom: widget.chatRoom,
          ),
        ],
      ),
    );
  }
}
