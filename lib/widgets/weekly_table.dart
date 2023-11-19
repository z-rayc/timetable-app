import 'package:flutter/material.dart';

class WeekTable extends StatelessWidget {
  const WeekTable({super.key});

  Widget horizontalDayItem(String day) {
    return Container(
      width: 300,
      child: Center(
        child: Text(day),
      ),
    );
  }

  Widget verticalHourItem(String hour) {
    return Container(
      height: 100,
      child: Center(
        child: Text(hour),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    final hours = [
      '8:00',
      '9:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00'
    ];

    return SizedBox(
      height: 1000,
      width: 1000,
      child: Stack(
        children: [
          Positioned(
            top: 50,
            child: Container(
              height: hours.length * 100,
              width: 50,
              color: Colors.red,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  for (var hour in hours) verticalHourItem(hour),
                ],
              ),
            ),
          ),
          Positioned(
            left: 50,
            child: Container(
              height: 50,
              width: days.length * 300,
              color: Colors.green,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  for (var day in days) horizontalDayItem(day),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
