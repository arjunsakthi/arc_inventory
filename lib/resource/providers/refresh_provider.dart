import 'package:flutter_riverpod/flutter_riverpod.dart';

class refreshNotifier extends StateNotifier<bool> {
  refreshNotifier() : super(true);

  void refresh() {
    state = !state;
  }
}

final refreshProvider = StateNotifierProvider<refreshNotifier, bool>(
  (ref) => refreshNotifier(),
);


// just for refreshing between blogwidget and BlogElementGrid for updating