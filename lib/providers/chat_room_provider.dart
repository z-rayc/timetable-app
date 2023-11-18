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

  // void updateLastRead(String chatroomId) async {
  // final updatedRow = await kSupabase
  //     .from('ChatRoomMember')
  //     .update({
  //       'last_read': DateTime.now().toIso8601String(),
  //     })
  //     .eq('chatroom_id', chatroomId)
  //     .eq('user_id', kSupabase.auth.currentUser!.id)
  //     .select()
  //     .single();
  // final String returnedChatRoomId = updatedRow['chatroom_id'].toString();
  // final DateTime newLastRead = DateTime.parse(updatedRow['last_read']);

  // final currentChatRooms = state.value!;
  // ChatRoom oldChat =
  //     currentChatRooms.firstWhere((r) => r.id == returnedChatRoomId);
  // ChatRoom newChat = ChatRoom(
  //   id: oldChat.id,
  //   name: oldChat.name,
  //   lastRead: newLastRead,
  // );
  // state = AsyncValue.data(
  //   currentChatRooms
  //       .map((r) => r.id == returnedChatRoomId ? newChat : r)
  //       .toList(),
  // );
  // }

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

// class LastMessage {
//   final String lastMessage;
//   final bool isUnRead;
//   LastMessage(this.lastMessage, this.isUnRead);
// }

// class UnreadMessagesProvider extends AsyncNotifier<Map<String, LastMessage>> {
//   void _subscribeToChatRooms() {
//     final chatRooms = ref.read(chatRoomProvider).value;
//     if (chatRooms == null) {
//       return;
//     }

//     final List<String> chatIds = chatRooms.map((r) => r.id).toList();

//     // final resp = kSupabase
//     //     .from('ChatMessage')
//     //     .select()
//     //     .filter('chat_room_id', 'in', chatIds)
//     //     .then((value) => print(value));

//     final String filter = 'chat_room_id=in.(${chatIds.join(',')})';

//     kSupabase.channel('new-changes').on(
//       RealtimeListenTypes.postgresChanges,
//       ChannelFilter(
//         table: 'ChatMessage',
//         schema: 'public',
//         event: 'INSERT',
//         filter: filter,
//       ),
//       (payload, [reference]) {
//         List<ChatRoom> currentChatRooms = ref.read(chatRoomProvider).value!;
//         ChatMessage message = ChatMessage.fromJson(payload['new']);
//         DateTime lastRead = currentChatRooms
//             .firstWhere((r) => r.id == message.chatRoomId)
//             .lastRead;
//         final bool isUnread = lastRead.isBefore(message.sentAt) &&
//             message.authorId != kSupabase.auth.currentUser!.id;

//         final currentdata = state.value ?? {};
//         currentdata[message.chatRoomId] =
//             LastMessage(message.message, isUnread);
//         state = AsyncValue.data(currentdata);
//       },
//     ).subscribe();
//   }

//   @override
//   FutureOr<Map<String, LastMessage>> build() async {
//     final chatRooms = ref.watch(chatRoomProvider).value;
//     if (chatRooms == null) {
//       return {};
//     }
//     final List<String> chatIds = chatRooms.map((r) => r.id).toList();

//     final List<dynamic> res = await kSupabase
//         .from('chatroomlastmessage')
//         .select()
//         .filter('chat_room_id', 'in', chatIds);

//     List<ChatMessage> lastMessages = [];
//     for (var row in res) {
//       lastMessages.add(ChatMessage.fromJson(row));
//     }

//     final Map<String, LastMessage> lastMessagesMap = {};
//     for (var message in lastMessages) {
//       DateTime lastRead =
//           chatRooms.firstWhere((r) => r.id == message.chatRoomId).lastRead;
//       final bool isUnread = lastRead.isBefore(message.sentAt);

//       lastMessagesMap[message.chatRoomId] =
//           LastMessage(message.message, isUnread);
//     }

//     _subscribeToChatRooms();
//     return lastMessagesMap;
//   }
// }

// final unreadMessagesProvider =
//     AsyncNotifierProvider<UnreadMessagesProvider, Map<String, LastMessage>>(
//   () {
//     return UnreadMessagesProvider();
//   },
// );

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
