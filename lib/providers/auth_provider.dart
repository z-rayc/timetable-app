import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends AsyncNotifier<Session?> {
  void setSession(Session? session) {
    state = AsyncValue.data(session);
  }

  @override
  FutureOr<Session?> build() {
    return null;
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, Session?>(
  () {
    return AuthNotifier();
  },
);
