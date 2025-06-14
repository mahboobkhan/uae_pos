import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IssueDatePicker extends StatefulWidget {
  final void Function(DateTime dateTime)? onDateTimeSelected;

  const IssueDatePicker({super.key, this.onDateTimeSelected});

  @override
  State<IssueDatePicker> createState() => _IssueDatePickerState();
}

class _IssueDatePickerState extends State<IssueDatePicker> {
  DateTime _selectedDateTime = DateTime.now();

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });

    if (widget.onDateTimeSelected != null) {
      widget.onDateTimeSelected!(_selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat(
      'dd-MM-yyyy  -  hh:mm a',
    ).format(_selectedDateTime);

    return GestureDetector(
      onTap: _pickDateTime,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              formatted,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.calendar_month, color: Colors.red, size: 10),
        ],
      ),
    );
  }
}
