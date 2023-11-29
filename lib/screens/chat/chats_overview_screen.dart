import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/chat_room_provider.dart';
import 'package:timetable_app/screens/chat/chat_screen.dart';
import 'package:timetable_app/widgets/chat/chat_room_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Chats overview screen widget.
/// Displays a list of all chat rooms the user is a member of.
/// Chatrooms are displayed in form of [ChatRoomTile]s.
class ChatsOverviewScreen extends ConsumerWidget {
  const ChatsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncChatRooms = ref.watch(chatRoomProvider);

    return switch (asyncChatRooms) {
      AsyncData(:final value, :final isLoading) => RefreshIndicator(
          onRefresh: () => ref.refresh(chatRoomProvider.future),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : value.isNotEmpty
                  ? ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return ChatRoomTile(
                            chatRoom: value[index],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChatScreen(chatRoom: value[index]);
                                  },
                                ),
                              );
                            });
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.noChatsYet),
                          TextButton.icon(
                            onPressed: () {
                              ref.invalidate(chatRoomProvider);
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(AppLocalizations.of(context)!.refresh),
                          )
                        ],
                      ),
                    ),
        ),
      AsyncError() => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.errorFetchingChats),
              TextButton.icon(
                onPressed: () {
                  ref.invalidate(chatRoomProvider);
                },
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.refresh),
              )
            ],
          ),
        ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
