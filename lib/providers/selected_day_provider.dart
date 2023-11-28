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

  void goForward(int days) {
    state = state.copyWith(date: state.date.add(Duration(days: days)));
  }

  void goBackward(int days) {
    state = state.copyWith(date: state.date.subtract(Duration(days: days)));
  }
}

final dateSelectedProvider =
    StateNotifierProvider<DateSelectedNotifier, DateSelected>((ref) {
  return DateSelectedNotifier();
});
