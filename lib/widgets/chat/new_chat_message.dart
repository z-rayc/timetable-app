import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/chat_room.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Text field with a button to send a new message to a chat room.
class NewChatMessage extends ConsumerStatefulWidget {
  const NewChatMessage({super.key, required this.chatRoom});

  final ChatRoom chatRoom;

  @override
  ConsumerState<NewChatMessage> createState() => _NewChatMessageState();
}

class _NewChatMessageState extends ConsumerState<NewChatMessage> {
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
    try {
      await kSupabase.from('ChatMessage').insert({
        'message': chatMessage.trim(),
        'chat_room_id': widget.chatRoom.id,
        'sent_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.sendMessageError),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: chatController,
              enableSuggestions: true,
              autocorrect: true,
              minLines: 1,
              maxLines: 5,
              decoration: AppThemes.entryFieldTheme.copyWith(
                  hintText: AppLocalizations.of(context)!.sendMessage),
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
