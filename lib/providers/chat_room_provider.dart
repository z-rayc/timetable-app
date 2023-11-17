import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';
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
        .select('user_id, chatroom_id, ChatRoom(id, name)')
        .filter('user_id', 'eq', kSupabase.auth.currentUser!.id)
        .timeout(kDefaultTimeout);

    List<ChatRoom> tempChatRooms = [];

    for (var row in chatRoomsDynamic) {
      tempChatRooms.add(
        ChatRoom.fromJson(row['ChatRoom']),
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
