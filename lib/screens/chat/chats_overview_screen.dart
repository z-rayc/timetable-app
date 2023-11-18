import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/providers/chat_room_provider.dart';
import 'package:timetable_app/screens/chat/chat_screen.dart';
import 'package:timetable_app/widgets/chat/chat_room_tile.dart';

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
                          const Text('No chats yet! Create one!'),
                          TextButton.icon(
                            onPressed: () {
                              ref.invalidate(chatRoomProvider);
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                          )
                        ],
                      ),
                    ),
        ),
      AsyncError() => const Center(
          child: Text('Error fetching chats. Please try again later.'),
        ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
