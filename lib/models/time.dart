class Time {
  const Time(this.time);

  final DateTime time;

  String _dateToHourMinute() {
    return "${time.toLocal().hour.toString().padLeft(2, '0')}:${time.toLocal().minute.toString().padLeft(2, '0')}";
  }

  String _month(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        throw Exception("Invalid month");
    }
  }

  String _dateToDayMonthYear() {
    return "${time.toLocal().day.toString().padLeft(2, '0')}. ${_month(time.toLocal().month)} ${time.toLocal().year.toString()}";
  }

  String _dateToDayMonthYearHourMinute() {
    return "${_dateToDayMonthYear()}, ${_dateToHourMinute()}";
  }

  String get hourMinutes => _dateToHourMinute();
  String get dayMonthYear => _dateToDayMonthYear();
  String get dayMonthYearHourMinute => _dateToDayMonthYearHourMinute();
}
