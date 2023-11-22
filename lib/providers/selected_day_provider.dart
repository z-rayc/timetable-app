import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateSelected {
  late DateTime date;

  DateSelected({required this.date});

  DateSelected copyWith({
    DateTime? date,
  }) {
    return DateSelected(
      date: date ?? this.date,
    );
  }

  AsyncValue<DateSelected> toAsyncValue() {
    return AsyncValue.data(this);
  }
}

class DateSelectedNotifier extends AsyncNotifier<DateSelected> {
  @override
  FutureOr<DateSelected> build() async {
    return DateSelected(date: DateTime.now());
  }

  final dateSelectedProvider =
      AsyncNotifierProvider<DateSelectedNotifier, DateSelected>(() {
    return DateSelectedNotifier();
  });
}

final dateSelectedProvider =
    AsyncNotifierProvider<DateSelectedNotifier, DateSelected>(() {
  return DateSelectedNotifier();
});
