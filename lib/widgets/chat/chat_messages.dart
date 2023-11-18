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
  @override
  void initState() {
    super.initState();
    ref
        .read(chatRoomLastReadProvider.notifier)
        .updateLastRead(widget.chatRoom.id);
  }

  @override
  void deactivate() {
    ref
        .read(chatRoomLastReadProvider.notifier)
        .updateLastRead(widget.chatRoom.id);
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
