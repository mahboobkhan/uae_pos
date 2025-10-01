import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';

class CustomCupertinoCalendar extends StatelessWidget {
  final DateTime? minimumDateTime;
  final DateTime? maximumDateTime;
  final DateTime? initialDateTime;
  final DateTime? currentDateTime;
  final CupertinoCalendarMode mode;
  final double width;
  final ValueChanged<DateTime>? onDateTimeChanged;

  const CustomCupertinoCalendar({
    super.key,
    this.minimumDateTime,
    this.maximumDateTime,
    this.initialDateTime,
    this.currentDateTime,
    this.mode = CupertinoCalendarMode.dateTime,
    this.width = 350,
    this.onDateTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return SizedBox(
      width: width,
      child: CupertinoCalendar(

        minimumDateTime: minimumDateTime ?? now.subtract(const Duration(days: 365)), // Default: 1 year ago
        maximumDateTime: maximumDateTime ?? now.add(const Duration(days: 365)), // Default: 1 year ahead
        initialDateTime: initialDateTime ?? now,
        currentDateTime: currentDateTime ?? now,
        onDateTimeChanged: onDateTimeChanged,

      ),
    );
  }
}
