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

  get _reversedMessages => _messages.reversed.toList();

  void _addMessage(dynamic data) {
    ChatMessage message = ChatMessage.fromJson(data);
    setState(() {
      _messages.add(message);
    });
  }

  void _addInitialMessages() async {
    final List<dynamic> reponse = await kSupabase
        .from('ChatMessage')
        .select()
        .eq('chat_room_id', widget.chatRoom.id);
    // print(reponse);
    final List<ChatMessage> messages =
        reponse.map((e) => ChatMessage.fromJson(e)).toList();
    setState(() {
      _messages.addAll(messages);
    });
  }

  @override
  void initState() {
    super.initState();
    _addInitialMessages();
    // _messagesChannel =
    // kSupabase.channel('ChatMessage:chat_room_id=eq.${widget.chatRoom.id}');
    kSupabase.channel('schema-db-changes').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
          table: 'ChatMessage',
          schema: 'public',
          // filter: 'chat_room_id=eq.${widget.chatRoom.id}',
          event: '*'),
      (payload, [ref]) {
        // print('Received message');
        // print(payload);
        //{schema: public, table: ChatMessage, commit_timestamp: 2023-11-16T21:28:50.103Z, eventType: INSERT, new: {author_email: nokacper24@gmail.com, author_id: 98ec05ea-272f-48fb-ace6-e9ee6dbf4515, author_name: nokacper24, chat_room_id: 10, id: 20, message: test, sent_at: 2023-11-16T22:28:49.664107}, old: {}, errors: null}
        var newMessage = payload['new'];
        _addMessage(newMessage);
      },
    ).subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
          child: ListView.builder(
        reverse: true,
        itemCount: _reversedMessages.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_reversedMessages[index].authorName),
              subtitle: Text(_reversedMessages[index].message),
            ),
          );
        },
      )),
    );
  }
}
