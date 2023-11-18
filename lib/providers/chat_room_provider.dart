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

  void updateLastRead(String chatroomId) async {
    final updatedRow = await kSupabase
        .from('ChatRoomMember')
        .update({
          'last_read': DateTime.now().toIso8601String(),
        })
        .eq('chatroom_id', chatroomId)
        .eq('user_id', kSupabase.auth.currentUser!.id)
        .select()
        .single();
    final String returnedChatRoomId = updatedRow['chatroom_id'].toString();
    final DateTime newLastRead = DateTime.parse(updatedRow['last_read']);

    final currentChatRooms = state.value!;
    ChatRoom oldChat =
        currentChatRooms.firstWhere((r) => r.id == returnedChatRoomId);
    ChatRoom newChat = ChatRoom(
      id: oldChat.id,
      name: oldChat.name,
      lastRead: newLastRead,
    );
    state = AsyncValue.data(
      currentChatRooms
          .map((r) => r.id == returnedChatRoomId ? newChat : r)
          .toList(),
    );
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

class LastMessage {
  final String lastMessage;
  final bool isUnRead;
  LastMessage(this.lastMessage, this.isUnRead);
}

class UnreadMessagesProvider extends AsyncNotifier<Map<String, LastMessage>> {
  void _subscribeToChatRooms() {
    final chatRooms = ref.read(chatRoomProvider).value;
    if (chatRooms == null) {
      return;
    }

    final List<String> chatIds = chatRooms.map((r) => r.id).toList();

    // final resp = kSupabase
    //     .from('ChatMessage')
    //     .select()
    //     .filter('chat_room_id', 'in', chatIds)
    //     .then((value) => print(value));

    final String filter = 'chat_room_id=in.(${chatIds.join(',')})';

    kSupabase.channel('new-changes').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        table: 'ChatMessage',
        schema: 'public',
        event: 'INSERT',
        filter: filter,
      ),
      (payload, [reference]) {
        List<ChatRoom> currentChatRooms = ref.read(chatRoomProvider).value!;
        ChatMessage message = ChatMessage.fromJson(payload['new']);
        DateTime lastRead = currentChatRooms
            .firstWhere((r) => r.id == message.chatRoomId)
            .lastRead;
        final bool isUnread = lastRead.isBefore(message.sentAt) &&
            message.authorId != kSupabase.auth.currentUser!.id;

        final currentdata = state.value ?? {};
        currentdata[message.chatRoomId] =
            LastMessage(message.message, isUnread);
        state = AsyncValue.data(currentdata);
      },
    ).subscribe();
  }

  @override
  FutureOr<Map<String, LastMessage>> build() async {
    final chatRooms = ref.watch(chatRoomProvider).value;
    if (chatRooms == null) {
      return {};
    }
    final List<String> chatIds = chatRooms.map((r) => r.id).toList();

    final List<dynamic> res = await kSupabase
        .from('chatroomlastmessage')
        .select()
        .filter('chat_room_id', 'in', chatIds);

    List<ChatMessage> lastMessages = [];
    for (var row in res) {
      lastMessages.add(ChatMessage.fromJson(row));
    }

    final Map<String, LastMessage> lastMessagesMap = {};
    for (var message in lastMessages) {
      DateTime lastRead =
          chatRooms.firstWhere((r) => r.id == message.chatRoomId).lastRead;
      final bool isUnread = lastRead.isBefore(message.sentAt);

      lastMessagesMap[message.chatRoomId] =
          LastMessage(message.message, isUnread);
    }

    _subscribeToChatRooms();
    return lastMessagesMap;
  }
}

final unreadMessagesProvider =
    AsyncNotifierProvider<UnreadMessagesProvider, Map<String, LastMessage>>(
  () {
    return UnreadMessagesProvider();
  },
);
