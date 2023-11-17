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
        .eq('chat_room_id', widget.chatRoom.id)
        .order('sent_at', ascending: true)
        .limit(200);
    final List<ChatMessage> messages =
        reponse.map((e) => ChatMessage.fromJson(e)).toList();
    setState(() {
      _messages.addAll(messages);
    });
  }

  void _subscribeToMessages() {
    kSupabase.channel('schema-db-changes').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        table: 'ChatMessage',
        schema: 'public',
        event: 'INSERT',
        filter: 'chat_room_id=eq.${widget.chatRoom.id}',
      ),
      (payload, [ref]) {
        var newMessage = payload['new'];
        _addMessage(newMessage);
      },
    ).subscribe();
  }

  @override
  void initState() {
    super.initState();
    _addInitialMessages();
    _subscribeToMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
      ),
    );
  }
}
