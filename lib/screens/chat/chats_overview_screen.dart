import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/chat_room.dart';
import 'package:timetable_app/screens/chat/chat_screen.dart';
import 'package:timetable_app/widgets/chat/chat_room_tile.dart';

class ChatsOverviewScreen extends StatefulWidget {
  const ChatsOverviewScreen({super.key});

  @override
  State<ChatsOverviewScreen> createState() => _ChatsOverviewScreenState();
}

class _ChatsOverviewScreenState extends State<ChatsOverviewScreen> {
  List<ChatRoom> _chatRooms = [];
  bool _isLoading = true;

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  void _fetchChatRooms() async {
    List<dynamic> chatRoomsDynamic = await kSupabase
        .from('ChatRoomMember')
        .select('userid, chatroomid, ChatRoom(id, name)')
        .filter('userid', 'eq', kSupabase.auth.currentUser!.id);

    List<ChatRoom> tempChatRooms = [];

    for (var row in chatRoomsDynamic) {
      tempChatRooms.add(
        ChatRoom(
          id: row['ChatRoom']['id'].toString(),
          name: row['ChatRoom']['name'],
        ),
      );
    }

    setState(() {
      _chatRooms = tempChatRooms;
    });
    _setLoading(false);
  }

  void _createChatRoom() async {
    _setLoading(true);

    List<String> emails = ["kacper@email.com", "email@email.com"];
    try {
      var response = await kSupabase.functions.invoke('createChatRoom', body: {
        'chatroomName': 'newchatroom',
        'memberEmails': emails,
      });
      print(response);
      print(response.status);
      print(response.data);
    } on Exception catch (e) {
      print(e);
    }

    _fetchChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    const chatroom = sampleChatRoom;
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _chatRooms.isEmpty
                ? const Center(
                    child: Text('No chats yet! Create one!'),
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _createChatRoom,
                        child: const Text('Create test chat room'),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _chatRooms.length,
                          itemBuilder: (context, index) {
                            return ChatRoomTile(
                                chatRoom: _chatRooms[index],
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const ChatScreen(
                                            chatRoom: chatroom);
                                      },
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  ));
  }
}
