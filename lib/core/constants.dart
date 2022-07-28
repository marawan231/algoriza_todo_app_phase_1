import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

showScaffold({required var text, required context, Color? color}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text.toString(),
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
    ),
  );
}

int idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch;
}

final remindTimes = [
  '10 minutes early',
  '30 minutes early',
  '1 hour early',
  '1 Day'
];
final repeatTimes = [
  'Daily',
  'Weakly',
  'Monthly',
];

int selectedIndex = -1;
List months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];
List selectedIndexs = [];

DateTime date = DateTime.now();
TimeOfDay timeNow = TimeOfDay.now();

var selectedDateFor = DateFormat("yyyy/MM/dd").format(date);

var dates = List<DateTime>.generate(
    30,
    (i) => DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).add(Duration(days: i)));
