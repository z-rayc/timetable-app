import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentification state notifier
/// Set session or null to change the authentification state.
/// Watch this provider in consumers depending on the user authentification.
/// Solves the issue of providers having old data if the user logs out and logs in as a different user.
class AuthNotifier extends AsyncNotifier<Session?> {
  void setSession(Session? session) {
    state = AsyncValue.data(session);
  }

  @override
  FutureOr<Session?> build() {
    return null;
  }
}
/// Watch this provider in consumers depending on the user authentification.
/// 
/// Consumers watching this provider will rebuild when the user logs in or out.
final authProvider = AsyncNotifierProvider<AuthNotifier, Session?>(
  () {
    return AuthNotifier();
  },
);
