import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/user_profile.dart';
import 'package:timetable_app/providers/auth_provider.dart';

/// Provider for the user profile of the currently logged in user.
class UserProfileProvider extends AsyncNotifier<UserProfile> {
  @override
  FutureOr<UserProfile> build() async {
    ref.watch(authProvider);
    final userProfile = await _fetchUserProfile();
    return userProfile;
  }

  /// Set the nickname of the currently logged in user.
  Future<void> setNickname(String nickname) async {
    final userId = kSupabase.auth.currentUser!.id;
    final userProfile = state.value;
    state = const AsyncValue.loading();
    try {
      final response = await kSupabase
          .from('UserProfile')
          .update({
            'nickname': nickname,
          })
          .eq('id', userId)
          .select()
          .single();

      final newProfile = UserProfile.fromJson(response);
      state = AsyncValue.data(newProfile);
    } on PostgrestException catch (e, stack) {
      if (userProfile != null) {
        state = AsyncValue.data(userProfile);
      } else {
        state = AsyncValue.error(e, stack);
      }
      if (e.code == '23505') {
        throw UserProfileProviderException('Nickname already taken');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
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

class UserProfileProviderException implements Exception {
  final String message;
  UserProfileProviderException(this.message);
}

/// Provider for profile of the currently logged in user.
/// Provides API to update the user's nickname.
final userProfileProvider =
    AsyncNotifierProvider<UserProfileProvider, UserProfile>(
  () {
    return UserProfileProvider();
  },
);
