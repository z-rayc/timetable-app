import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/models/chat_message.dart';
import 'package:timetable_app/models/chat_room.dart';
import 'package:timetable_app/providers/chat_room_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final Map<String, (ChatMessage?, bool)> unreadMessages =
        ref.watch(unreadMessagesProvider);

    bool hasUnread = false;
    String subtitleText = AppLocalizations.of(context)!.noMessagesYet;

    final (ChatMessage?, bool)? lastMessageTuple = unreadMessages[chatRoom.id];
    if (lastMessageTuple != null) {
      final ChatMessage? message = lastMessageTuple.$1;
      hasUnread = lastMessageTuple.$2;
      if (message != null) {
        subtitleText = '${message.authorNickName}: ${message.message}';
      }
    }

    return Card(
      child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          leading: CircleAvatar(
            child: Icon(chatRoom.isCourseChat ? Icons.school : Icons.chat),
          ),
          title: Text(
            chatRoom.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            subtitleText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: hasUnread
              ? const Icon(
                  Icons.circle_notifications,
                  color: Colors.red,
                )
              : null),
    );
  }
}
