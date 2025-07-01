import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  /// The argument value will return the changed date as [DateTime] when the
  /// widget [SfDateRangeSelectionMode] set as single.
  ///
  /// The argument value will return the changed dates as [List<DateTime>]
  /// when the widget [SfDateRangeSelectionMode] set as multiple.
  ///
  /// The argument value will return the changed range as [PickerDateRange]
  /// when the widget [SfDateRangeSelectionMode] set as range.
  ///
  /// The argument value will return the changed ranges as
  /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
  /// multi range.
}

Future<PickerDateRange?> showDateRangePickerDialog(BuildContext context) async {
  PickerDateRange? selectedRange;

  return await showDialog<PickerDateRange>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: 380,
          height: 440,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Date Range',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        color: Colors.grey,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /*SfDateRangePicker(
                    selectionMode: DateRangePickerSelectionMode.range,
                    showNavigationArrow: true,
                    allowViewNavigation: true,
                    initialSelectedRange: PickerDateRange(
                      DateTime.now().subtract(const Duration(days: 4)),
                      DateTime.now().add(const Duration(days: 3)),
                    ),
                    view: DateRangePickerView.month,
                    navigationMode: DateRangePickerNavigationMode.snap,
                    headerStyle: const DateRangePickerHeaderStyle(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    selectionColor: Colors.deepPurple,
                    startRangeSelectionColor: Colors.deepPurple,
                    endRangeSelectionColor: Colors.deepPurple,
                    rangeSelectionColor: Colors.deepPurple.withOpacity(0.2),
                    todayHighlightColor: Colors.orange,
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: TextStyle(color: Colors.black),
                      todayTextStyle: TextStyle(color: Colors.orange),
                      disabledDatesTextStyle: TextStyle(color: Colors.grey),
                    ),
                    onSelectionChanged: (args) {
                      if (args.value is PickerDateRange) {
                        // handle selected range
                      }
                    },
                  ),*/
                  SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                      DateTime.now().subtract(const Duration(days: 4)),
                      DateTime.now().add(const Duration(days: 3)),
                    ),
                    startRangeSelectionColor: Colors.blue,
                    endRangeSelectionColor: Colors.blue,
                    rangeSelectionColor: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  // Show selected range
                  if (selectedRange != null) ...[
                    Text(
                      'Selected Range:',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat('dd/MM/yyyy').format(selectedRange.startDate!)}'
                      ' - '
                      '${DateFormat('dd/MM/yyyy').format(selectedRange.endDate ?? selectedRange.startDate!)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),

                        child: const Text('CANCEL',style: TextStyle(color: Colors.blue),),
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        onPressed: () {
                          if (selectedRange != null) {
                            Navigator.pop(context, selectedRange);
                          }
                        },
                       text: "Save",
                        backgroundColor: Colors.blue,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
