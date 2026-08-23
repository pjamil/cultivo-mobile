import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final authEventsProvider = Provider<AuthEvents>((ref) {
  final events = AuthEvents();
  ref.onDispose(events.dispose);
  return events;
});

class AuthEvents {
  final StreamController<void> _sessionExpired = StreamController.broadcast();

  Stream<void> get sessionExpired => _sessionExpired.stream;

  void notifySessionExpired() {
    if (!_sessionExpired.isClosed) {
      _sessionExpired.add(null);
    }
  }

  void dispose() {
    _sessionExpired.close();
  }
}
