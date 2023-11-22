import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/chat_room.dart';
import 'package:timetable_app/providers/chat_room_provider.dart';
import 'package:timetable_app/screens/chat/new_chat_overlay.dart';
import 'package:timetable_app/widgets/chat/chat_messages.dart';
import 'package:timetable_app/widgets/chat/new_chat_message.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.chatRoom});
  final ChatRoom chatRoom;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  void _handleMenuSelection(int value) {
    switch (value) {
      case 0:
        _leaveChat();
        break;
      default:
    }
  }

  void _leaveChat() {
    ref.read(chatRoomProvider.notifier).leaveChat(widget.chatRoom.id);
    Navigator.of(context).pop();
  }

  void _showNewChatOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return NewChatOverlay(chatRoom: widget.chatRoom);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOwner =
        widget.chatRoom.ownerId == kSupabase.auth.currentUser!.id;

    final Widget acion = isOwner
        ? IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showNewChatOverlay,
          )
        : PopupMenuButton<int>(
            onSelected: (value) => _handleMenuSelection(value),
            itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: AppThemes.theme.colorScheme.onBackground,
                        ),
                        const Text('Leave Chat'),
                      ],
                    ),
                  ),
                ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoom.name),
        actions: [if (!widget.chatRoom.isCourseChat) acion],
      ),
      body: Column(
        children: [
          ChatMessages(chatRoom: widget.chatRoom),
          NewChatMessage(chatRoom: widget.chatRoom),
        ],
      ),
    );
  }
}
