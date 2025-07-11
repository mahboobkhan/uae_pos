import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
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
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.5,         // Border width
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          color: Colors.grey,
                          onPressed: () => Navigator.pop(context),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.red,
                      ),
                    ),
                    child: SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 4)),
                        DateTime.now().add(const Duration(days: 3)),
                      ),
                      startRangeSelectionColor: Colors.red,
                      endRangeSelectionColor: Colors.red,
                      rangeSelectionColor: Colors.red.shade100,
                    ),
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
