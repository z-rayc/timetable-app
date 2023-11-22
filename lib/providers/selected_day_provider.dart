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

class DateSelectedNotifier extends StateNotifier<DateSelected> {
  DateSelectedNotifier() : super(DateSelected(date: DateTime.now()));

  void setDate(DateTime newDate) {
    state = state.copyWith(date: newDate);
  }

  void goForward() {
    state = state.copyWith(date: state.date.add(const Duration(days: 1)));
  }

  void goBackward() {
    state = state.copyWith(date: state.date.subtract(const Duration(days: 1)));
  }
}

final dateSelectedProvider =
    StateNotifierProvider<DateSelectedNotifier, DateSelected>((ref) {
  return DateSelectedNotifier();
});
