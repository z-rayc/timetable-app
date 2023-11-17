import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/chat_message.dart';
import 'package:timetable_app/models/chat_room.dart';

class ChatRoomProvicer extends AsyncNotifier<List<ChatRoom>> {
  @override
  FutureOr<List<ChatRoom>> build() async {
    return _fetchChatRooms();
  }

  Future<ChatRoomCreationError?> addChatRoom(
      String chatName, List<String> emails) async {
    ChatRoomCreationError? maybeError;
    state = const AsyncValue.loading();
    // AsyncValue.guard();
    try {
      var response = await kSupabase.functions.invoke('createChatRoom', body: {
        'chatroomName': chatName,
        'memberEmails': emails,
      }).timeout(kDefaultTimeout);

      if (response.status != 201) {
        maybeError = ChatRoomCreationError(response.data['error']);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
    // state = AsyncValue.data(await _fetchChatRooms());
    ref.invalidateSelf();
    return maybeError;
  }

  Future<List<ChatRoom>> _fetchChatRooms() async {
    List<dynamic> chatRoomsDynamic = await kSupabase
        .from('ChatRoomMember')
        .select('user_id, chatroom_id, last_read, ChatRoom(id, name)')
        .filter('user_id', 'eq', kSupabase.auth.currentUser!.id)
        .timeout(kDefaultTimeout);

    List<ChatRoom> tempChatRooms = [];

    for (var row in chatRoomsDynamic) {
      tempChatRooms.add(
        ChatRoom.fromJson(row['ChatRoom'], lastRead: row['last_read']),
      );
    }
    return tempChatRooms;
  }
}

final chatRoomProvider =
    AsyncNotifierProvider<ChatRoomProvicer, List<ChatRoom>>(
  () {
    return ChatRoomProvicer();
  },
);

class ChatRoomCreationError {
  final String message;
  ChatRoomCreationError(this.message);
  @override
  String toString() {
    return message;
  }
}

// provider for unread messages

class UnreadMessagesProvider extends AsyncNotifier<Map<ChatRoom, bool>> {
  // List<ChatRoom> _getChatRooms() {
  //   var currentChats = ref.watch(chatRoomProvider);
  //   if (currentChats.hasValue && currentChats.value != null) {
  //     return currentChats.value!;
  //   } else {
  //     return [];
  //   }
  // }

  // void _subscribeToChatRooms() {
  //   final chatIds = _getChatRooms().map((r) => r.id).toList();

  //   kSupabase.channel('schema-db-changes').on(
  //     RealtimeListenTypes.postgresChanges,
  //     ChannelFilter(
  //       table: 'ChatMessage',
  //       schema: 'public',
  //       event: 'INSERT',
  //       filter: 'chat_room_id=in.(${chatIds.join(',')})',
  //     ),
  //     (payload, [ref]) {
  //       var newMessage = payload['new'];
  //     },
  //   ).subscribe();
  // }

  @override
  FutureOr<Map<ChatRoom, bool>> build() async {
    final chatRooms = ref.watch(chatRoomProvider).value;
    if (chatRooms == null) {
      return {};
    }

    Map<String, DateTime> lastReads = {
      for (var chatRoom in chatRooms) chatRoom.id: chatRoom.lastRead,
    };

    final List<dynamic> res =
        await kSupabase.from('chatroomlastmessage').select();

    List<ChatMessage> lastMessages = [];
    for (var row in res) {
      lastMessages.add(ChatMessage.fromJson(row));
    }

    Map<ChatRoom, ChatMessage> lastMessagesMap = {
      for (var message in lastMessages)
        chatRooms.firstWhere((r) => r.id == message.chatRoomId): message,
    };

    Map<ChatRoom, bool> unreadInChatRooms = {};

    for (var entry in lastMessagesMap.entries) {
      if (lastReads[entry.key.id]!.isBefore(entry.value.sentAt)) {
        unreadInChatRooms[entry.key] = true;
      } else {
        unreadInChatRooms[entry.key] = false;
      }
    }

    return unreadInChatRooms;
  }
}

final unreadMessagesProvider =
    AsyncNotifierProvider<UnreadMessagesProvider, Map<ChatRoom, bool>>(
  () {
    return UnreadMessagesProvider();
  },
);
