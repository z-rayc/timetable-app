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

    kSupabase.channel('schema-db-changes').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(table: 'ChatMessage', schema: 'public', event: '*'),
      (payload, [ref]) {
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
