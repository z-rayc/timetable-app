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
    final unread = ref.watch(unreadMessagesProvider);
    bool hasUnread = false;
    if (unread.value != null && unread.value!.containsKey(chatRoom)) {
      hasUnread = unread.value![chatRoom]!;
    }
    return Card(
      child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          leading: const CircleAvatar(
            child: Icon(Icons.chat),
          ),
          title: Text(chatRoom.name),
          subtitle: const Text('Last message'),
          trailing: hasUnread
              ? const CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 5,
                )
              : null),
    );
  }
}
