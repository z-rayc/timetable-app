import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/models/chat_message.dart';
import 'package:timetable_app/models/chat_room.dart';
import 'package:timetable_app/providers/chat_room_provider.dart';

class ChatRoomTile extends ConsumerWidget {
  const ChatRoomTile({
    super.key,
    required this.chatRoom,
    this.onTap,
    this.onLongPress,
  });
  final ChatRoom chatRoom;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatMessage? message =
        ref.watch(chatMessagesProvider).value?[chatRoom.id]?.last;
    final DateTime? lastRead =
        ref.watch(chatRoomLastReadProvider).value?[chatRoom.id];

    bool hasUnread = false;
    String lastMessage = 'No messages yet...';

    if (message != null) {
      if (lastRead != null && message.sentAt.isAfter(lastRead)) {
        hasUnread = true;
      }
      lastMessage = message.message;
    }

    return Card(
      child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          leading: const CircleAvatar(
            child: Icon(Icons.chat),
          ),
          title: Text(chatRoom.name),
          subtitle: Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: hasUnread
              ? const CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 5,
                )
              : null),
    );
  }
}
