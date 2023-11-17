import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/chat_room.dart';

class NewChatMessage extends StatefulWidget {
  const NewChatMessage({super.key, required this.chatRoom});

  final ChatRoom chatRoom;

  @override
  State<NewChatMessage> createState() => _NewChatMessageState();
}

class _NewChatMessageState extends State<NewChatMessage> {
  final chatController = TextEditingController();

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  void _submitChatMessage() async {
    String chatMessage = chatController.text;
    if (chatMessage.trim().isEmpty) {
      return;
    }
    chatController.clear();
    FocusScope.of(context).unfocus();

    User currentUser = kSupabase.auth.currentUser!;
    String username = currentUser.email!.split('@')[0];
    try {
      await kSupabase.from('ChatMessage').insert({
        'message': chatMessage,
        'chat_room_id': widget.chatRoom.id,
        'author_name': username,
        'sent_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error sending message'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatController,
              enableSuggestions: true,
              autocorrect: true,
              decoration: AppThemes.entryFieldTheme
                  .copyWith(hintText: 'Send a message'),
            ),
          ),
          IconButton(
            color: AppThemes.theme.primaryColor,
            onPressed: _submitChatMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
