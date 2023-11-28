import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/user_profile.dart';
import 'package:timetable_app/providers/auth_provider.dart';

class UserProfileProvider extends AsyncNotifier<UserProfile> {
  @override
  FutureOr<UserProfile> build() async {
    ref.watch(authProvider);
    final userProfile = await _fetchUserProfile();
    return userProfile;
  }

  Future<void> setNickname(String nickname) async {
    final userId = kSupabase.auth.currentUser!.id;
    state = const AsyncValue.loading();
    final response = await kSupabase
        .from('UserProfile')
        .update({
          'nickname': nickname,
        })
        .eq('id', userId)
        .select()
        .single();
    print(response);
    final newProfile = UserProfile.fromJson(response);
    print(newProfile);
    state = AsyncValue.data(newProfile);
  }

  Future<UserProfile> _fetchUserProfile() async {
    final userId = kSupabase.auth.currentUser!.id;
    final resp = await kSupabase
        .from('UserProfile')
        .select<Map<String, dynamic>>()
        .eq('id', userId)
        .single();
    final userProfile = UserProfile.fromJson(resp);
    return userProfile;
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileProvider, UserProfile>(
  () {
    return UserProfileProvider();
  },
);
