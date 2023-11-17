import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final unreadMessage = ref.watch(unreadMessagesProvider);
    bool hasUnread = false;
    String lastMessage = 'No messages yet';
    if (unreadMessage.value != null &&
        unreadMessage.value!.containsKey(chatRoom.id)) {
      hasUnread = unreadMessage.value![chatRoom.id]!.isUnRead;
      lastMessage = unreadMessage.value![chatRoom.id]!.lastMessage;
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
