import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/chat_message.dart';
import 'package:timetable_app/models/chat_room.dart';
import 'package:timetable_app/providers/chat_room_provider.dart';
import 'package:timetable_app/widgets/chat/chat_bubble.dart';

class ChatMessages extends ConsumerStatefulWidget {
  const ChatMessages({super.key, required this.chatRoom});
  final ChatRoom chatRoom;

  @override
  ConsumerState<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends ConsumerState<ChatMessages> {
  // final List<ChatMessage> _messages = [];
  // final RealtimeChannel _channel = kSupabase.channel('schema-db-changes');

  // get _reversedMessages => _messages.reversed.toList();

  // void _addMessage(dynamic data) {
  //   ChatMessage message = ChatMessage.fromJson(data);
  //   setState(() {
  //     _messages.add(message);
  //   });
  // }

  // void _addInitialMessages() async {
  // final List<dynamic> reponse = await kSupabase
  //     .from('ChatMessage')
  //     .select()
  //     .eq('chat_room_id', widget.chatRoom.id)
  //     .order('sent_at', ascending: true)
  //     .limit(200);
  // final List<ChatMessage> messages =
  //     reponse.map((e) => ChatMessage.fromJson(e)).toList();
  // setState(() {
  //   _messages.addAll(messages);
  // });
  // ref.read(chatMessagesProvider).whenData((value) {
  //   setState(() {
  //     _messages.addAll(value[widget.chatRoom.id] ?? []);
  //   });
  // });
  // }

  // void _subscribeToMessages() {
  //   _channel.on(
  //     RealtimeListenTypes.postgresChanges,
  //     ChannelFilter(
  //       table: 'ChatMessage',
  //       schema: 'public',
  //       event: 'INSERT',
  //       filter: 'chat_room_id=eq.${widget.chatRoom.id}',
  //     ),
  //     (payload, [ref]) {
  //       var newMessage = payload['new'];
  //       _addMessage(newMessage);
  //     },
  //   ).subscribe();
  // }

  @override
  void initState() {
    super.initState();
    // _addInitialMessages();
    // _subscribeToMessages();
    // ref.read(chatRoomProvider.notifier).updateLastRead(widget.chatRoom.id);
    ref
        .read(chatRoomLastReadProvider.notifier)
        .updateLastRead(widget.chatRoom.id);
  }

  @override
  void deactivate() {
    // ref.read(chatRoomProvider.notifier).updateLastRead(widget.chatRoom.id);
    ref
        .read(chatRoomLastReadProvider.notifier)
        .updateLastRead(widget.chatRoom.id);
    // kSupabase.removeChannel(_channel);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChatMessage> messages =
        ref.watch(chatMessagesProvider).value?[widget.chatRoom.id] ?? [];
    final List<ChatMessage> reversedMessages = messages.reversed.toList();
    final currentUserId = kSupabase.auth.currentUser!.id;

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        reverse: true,
        itemCount: reversedMessages.length,
        itemBuilder: (context, index) {
          final currentMessage = reversedMessages[index];
          bool isMe = currentMessage.authorId == currentUserId;
          ChatBubbleOrder order;
          String currentAuthorId = currentMessage.authorId;
          String? previousAuthorId = index + 1 < reversedMessages.length
              ? reversedMessages[index + 1].authorId
              : null;
          String? nextAuthorId =
              index - 1 >= 0 ? reversedMessages[index - 1].authorId : null;
          if (currentAuthorId != previousAuthorId &&
              currentAuthorId != nextAuthorId) {
            order = ChatBubbleOrder.firstAndLast;
          } else if (currentAuthorId != previousAuthorId) {
            order = ChatBubbleOrder.first;
          } else if (currentAuthorId != nextAuthorId) {
            order = ChatBubbleOrder.last;
          } else {
            order = ChatBubbleOrder.middle;
          }

          return ChatBubble(
            message: currentMessage,
            isMe: isMe,
            order: order,
          );
        },
      ),
    );
  }
}
