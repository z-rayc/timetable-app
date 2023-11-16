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
        .select('user_id, chatroom_id, ChatRoom(id, name)')
        .filter('user_id', 'eq', kSupabase.auth.currentUser!.id);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _chatRooms.isEmpty
              ? const Center(
                  child: Text('No chats yet! Create one!'),
                )
              : ListView.builder(
                  itemCount: _chatRooms.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        chatRoom: _chatRooms[index],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ChatScreen(chatRoom: _chatRooms[index]);
                              },
                            ),
                          );
                        });
                  },
                ),
    );
  }
}
