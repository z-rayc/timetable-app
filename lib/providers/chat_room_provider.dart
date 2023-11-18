import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/chat_message.dart';
import 'package:timetable_app/models/chat_room.dart';

class ChatRoomProvicer extends AsyncNotifier<List<ChatRoom>> {
  @override
  FutureOr<List<ChatRoom>> build() async {
    _subscribeToChatRooms();
    return _fetchChatRooms();
  }

  void _subscribeToChatRooms() {
    kSupabase.channel('new-chatrooms').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        table: 'ChatRoomMember',
        schema: 'public',
        event: 'INSERT',
        filter: 'user_id=eq.${kSupabase.auth.currentUser!.id}',
      ),
      (payload, [reference]) {
        ref.invalidateSelf();
      },
    ).subscribe();
  }

  Future<ChatRoomCreationError?> addChatRoom(
      String chatName, List<String> emails) async {
    ChatRoomCreationError? maybeError;
    state = const AsyncValue.loading();
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

class ChatRoomLastReadProvider extends AsyncNotifier<Map<String, DateTime>> {
  void updateLastRead(String chatRoomId) async {
    final updatedRow = await kSupabase
        .from('ChatRoomMember')
        .update({
          'last_read': DateTime.now().toIso8601String(),
        })
        .eq('chatroom_id', chatRoomId)
        .eq('user_id', kSupabase.auth.currentUser!.id)
        .select()
        .single();
    final String returnedChatRoomId = updatedRow['chatroom_id'].toString();
    final DateTime newLastRead = DateTime.parse(updatedRow['last_read']);

    final Map<String, DateTime> dataClone = Map.of(state.value ?? {});
    dataClone[returnedChatRoomId] = newLastRead;
    state = AsyncValue.data(dataClone);
  }

  @override
  FutureOr<Map<String, DateTime>> build() async {
    final chatRooms = ref.watch(chatRoomProvider).value;
    if (chatRooms == null) {
      return {};
    }
    final List<String> chatIds = chatRooms.map((r) => r.id).toList();

    final List<dynamic> res = await kSupabase
        .from('ChatRoomMember')
        .select('user_id, chatroom_id, last_read')
        .filter('user_id', 'eq', kSupabase.auth.currentUser!.id)
        .filter('chatroom_id', 'in', chatIds);
    final Map<String, DateTime> lastReadMap = {};
    for (var row in res) {
      lastReadMap[row['chatroom_id'].toString()] =
          DateTime.parse(row['last_read']);
    }

    return lastReadMap;
  }
}

final chatRoomLastReadProvider =
    AsyncNotifierProvider<ChatRoomLastReadProvider, Map<String, DateTime>>(
  () {
    return ChatRoomLastReadProvider();
  },
);

class ChatMessagesProvider
    extends AsyncNotifier<Map<String, List<ChatMessage>>> {
  void _subscribeToAllChatRooms() {
    final chatRooms = ref.read(chatRoomProvider).value;
    if (chatRooms == null) {
      return;
    }
    final List<String> chatIds = chatRooms.map((r) => r.id).toList();
    final String filter = 'chat_room_id=in.(${chatIds.join(',')})';

    kSupabase.channel('new-chat-messages').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        table: 'ChatMessage',
        schema: 'public',
        event: 'INSERT',
        filter: filter,
      ),
      (payload, [reference]) {
        ChatMessage message = ChatMessage.fromJson(payload['new']);
        final Map<String, List<ChatMessage>> dataClone =
            Map.of(state.value ?? {});
        if (dataClone[message.chatRoomId] == null) {
          dataClone[message.chatRoomId] = [];
        }
        dataClone[message.chatRoomId]!.add(message);
        state = AsyncValue.data(dataClone);
      },
    ).subscribe();
  }

  @override
  FutureOr<Map<String, List<ChatMessage>>> build() async {
    final chatRooms = ref.watch(chatRoomProvider).value;
    if (chatRooms == null) {
      return {};
    }
    final List<String> chatIds = chatRooms.map((r) => r.id).toList();

    final List<dynamic> reponse = await kSupabase
        .from('ChatMessage')
        .select()
        .in_('chat_room_id', chatIds)
        .order('chat_room_id', ascending: true)
        .order('sent_at', ascending: true)
        .limit(1000);
    final List<ChatMessage> messages =
        reponse.map((e) => ChatMessage.fromJson(e)).toList();

    final Map<String, List<ChatMessage>> messagesMap = {};
    for (var message in messages) {
      if (messagesMap[message.chatRoomId] == null) {
        messagesMap[message.chatRoomId] = [];
      }
      messagesMap[message.chatRoomId]!.add(message);
    }
    _subscribeToAllChatRooms();
    return messagesMap;
  }
}

final chatMessagesProvider =
    AsyncNotifierProvider<ChatMessagesProvider, Map<String, List<ChatMessage>>>(
  () {
    return ChatMessagesProvider();
  },
);
