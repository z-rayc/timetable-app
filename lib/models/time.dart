import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Time {
  const Time({required this.time, required this.context});

  final BuildContext context;
  final DateTime time;

  String _dateToHourMinute() {
    return "${time.toLocal().hour.toString().padLeft(2, '0')}:${time.toLocal().minute.toString().padLeft(2, '0')}";
  }

  String _month(int month) {
    switch (month) {
      case 1:
        return AppLocalizations.of(context)!.january;
      case 2:
        return AppLocalizations.of(context)!.february;
      case 3:
        return AppLocalizations.of(context)!.march;
      case 4:
        return AppLocalizations.of(context)!.april;
      case 5:
        return AppLocalizations.of(context)!.may;
      case 6:
        return AppLocalizations.of(context)!.june;
      case 7:
        return AppLocalizations.of(context)!.july;
      case 8:
        return AppLocalizations.of(context)!.august;
      case 9:
        return AppLocalizations.of(context)!.september;
      case 10:
        return AppLocalizations.of(context)!.october;
      case 11:
        return AppLocalizations.of(context)!.november;
      case 12:
        return AppLocalizations.of(context)!.december;
      default:
        throw Exception(AppLocalizations.of(context)!.invalidMonthError);
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
