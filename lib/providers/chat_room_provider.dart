import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/chat_message.dart';
import 'package:timetable_app/models/chat_room.dart';

class ChatRoomProvicer extends AsyncNotifier<List<ChatRoom>> {
  late RealtimeChannel _channel;

  ChatRoomProvicer() : super() {
    _channel = kSupabase.channel('new-chatrooms');
    _initialize();
  }

  void _initialize() {
    _subscribeToChatRooms();
  }

  @override
  FutureOr<List<ChatRoom>> build() async {
    return _fetchChatRooms();
  }

  void _subscribeToChatRooms() {
    final String filter = 'user_id=eq.${kSupabase.auth.currentUser!.id}';
    _channel
        .on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(
            table: 'ChatRoomMember',
            schema: 'public',
            event: 'INSERT',
            filter: filter,
          ),
          _onChatRoomChange,
        )
        .on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(
            table: 'ChatRoomMember',
            schema: 'public',
            event: 'DELETE',
            filter: filter,
          ),
          _onChatRoomChange,
        )
        .subscribe();
  }

  void _onChatRoomChange(dynamic payload, [dynamic reference]) {
    ref.invalidateSelf();
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
  List<String> _chatRoomIds = [];

  void _subscribeToAllChats() {
    final String filter = 'chat_room_id=in.(${_chatRoomIds.join(',')})';
    kSupabase
        .channel('new-chat-messages')
        .on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(
            table: 'ChatMessage',
            schema: 'public',
            event: 'INSERT',
            filter: filter,
          ),
          _onNewChatMessage,
        )
        .subscribe();
  }

  void _onNewChatMessage(dynamic payload, [dynamic reference]) {
    ChatMessage message = ChatMessage.fromJson(payload['new']);
    final Map<String, List<ChatMessage>> dataClone = Map.of(state.value ?? {});
    if (dataClone[message.chatRoomId] == null) {
      dataClone[message.chatRoomId] = [];
    }
    dataClone[message.chatRoomId]!.add(message);
    state = AsyncValue.data(dataClone);
  }

  @override
  FutureOr<Map<String, List<ChatMessage>>> build() async {
    final chatRooms = ref.watch(chatRoomProvider).value;
    if (chatRooms == null) {
      return {};
    }
    final List<String> chatIds = chatRooms.map((r) => r.id).toList();
    _chatRoomIds = chatIds;
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

    _subscribeToAllChats();
    return messagesMap;
  }
}

final chatMessagesProvider =
    AsyncNotifierProvider<ChatMessagesProvider, Map<String, List<ChatMessage>>>(
  () {
    return ChatMessagesProvider();
  },
);

/// Returns a map of chat room ids to a tuple of the last message and a bool
/// indicating if the last message is unread or not.
final unreadMessagesProvider =
    rp.Provider<Map<String, (ChatMessage?, bool)>>((ref) {
  final List<ChatRoom> chatRooms = ref.watch(chatRoomProvider).value ?? [];

  final Map<String, List<ChatMessage>> messages =
      ref.watch(chatMessagesProvider).value ?? {};

  final Map<String, ChatMessage?> lastMessages = {};
  for (var chatRoom in chatRooms) {
    lastMessages[chatRoom.id] = messages[chatRoom.id]?.last;
  }

  final Map<String, DateTime> lastReads =
      ref.watch(chatRoomLastReadProvider).value ?? {};

  final Map<String, (ChatMessage?, bool)> unreadMessages = {};
  for (var chatRoom in chatRooms) {
    final ChatMessage? lastMessage = lastMessages[chatRoom.id];
    final DateTime? lastRead = lastReads[chatRoom.id];
    bool hasUnread = false;
    if (lastMessage != null) {
      if (lastRead != null && lastMessage.sentAt.isAfter(lastRead)) {
        hasUnread = true;
      }
    }
    unreadMessages[chatRoom.id] = (lastMessage, hasUnread);
  }
  return unreadMessages;
});

final anyUndreadMessagesProvider = rp.Provider<bool>((ref) {
  final Map<String, (ChatMessage?, bool)> unreadMessages =
      ref.watch(unreadMessagesProvider);
  bool anyUnread = false;
  int index = 0;
  while (index < unreadMessages.length && !anyUnread) {
    anyUnread = unreadMessages.values.elementAt(index).$2;
    index++;
  }
  return anyUnread;
});
