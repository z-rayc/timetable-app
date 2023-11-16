import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/chat_message.dart';
import 'package:timetable_app/models/chat_room.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key, required this.chatRoom});
  final ChatRoom chatRoom;

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  late final RealtimeChannel _messagesChannel;
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messagesChannel =
        // kSupabase.channel('ChatMessage:chat_room_id=eq.${widget.chatRoom.id}');
        kSupabase.channel('schema-db-changes');
    print('Subscribing to messages channel');
    print(_messagesChannel);
    print(_messagesChannel.presenceState());
    _messagesChannel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
          table: 'ChatMessage',
          schema: 'public',
          // filter: 'chat_room_id=eq.${widget.chatRoom.id}',
          event: '*'),
      (payload, [ref]) {
        print('Received message');
        print(payload);
        //{schema: public, table: ChatMessage, commit_timestamp: 2023-11-16T21:28:50.103Z, eventType: INSERT, new: {author_email: nokacper24@gmail.com, author_id: 98ec05ea-272f-48fb-ace6-e9ee6dbf4515, author_name: nokacper24, chat_room_id: 10, id: 20, message: test, sent_at: 2023-11-16T22:28:49.664107}, old: {}, errors: null}
        var newMessage = payload['new'];
        setState(() {
          _messages.add(
            ChatMessage(
              id: newMessage['id'].toString(),
              authorId: newMessage['author_id'].toString(),
              authorName: newMessage['author_name'],
              authorEmail: newMessage['author_email'],
              chatRoomId: newMessage['chat_room_id'].toString(),
              message: newMessage['message'],
              sentAt: DateTime.parse(newMessage['sent_at']),
            ),
          );
        });
      },
    ).subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
          child: ListView.builder(
        reverse: true,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_messages[index].authorName),
            subtitle: Text(_messages[index].message),
          );
        },
      )),
    );
  }
}
