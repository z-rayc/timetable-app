import 'package:flutter/material.dart';
import 'package:timetable_app/models/chat_room.dart';
import 'package:timetable_app/screens/chat/chat_screen.dart';
import 'package:timetable_app/widgets/chat/chat_room_tile.dart';

class ChatsOverviewScreen extends StatelessWidget {
  const ChatsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const chatroom = sampleChatRoom;
    return Scaffold(
        body: ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return ChatRoomTile(
            chatRoom: chatroom,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ChatScreen(chatRoom: chatroom);
                  },
                ),
              );
            });
      },
    ));
  }
}
