import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Future<PickerDateRange?> showDateRangePickerDialog(BuildContext context) async {
  PickerDateRange? selectedRange;

  return await showDialog<PickerDateRange>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          height: 400,
          width: 400,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
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
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Expanded Date Picker
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.red,

                        ),
                      ),
                      child: SfDateRangePicker(
                        selectionColor: Colors.grey,
                        headerStyle: DateRangePickerHeaderStyle(
                          backgroundColor: Colors.white, // ✅ Month row background
                          textStyle: const TextStyle(
                            color: Colors.red, // ✅ Month text color
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),),
                        onSelectionChanged: (args) {
                          if (args.value is PickerDateRange) {
                            setState(() {
                              selectedRange = args.value;
                            });
                          }
                        },
                        selectionMode: DateRangePickerSelectionMode.range,
                        initialSelectedRange: PickerDateRange(
                          DateTime.now().subtract(const Duration(days: 4)),
                          DateTime.now().add(const Duration(days: 3)),
                        ),
                        startRangeSelectionColor: Colors.red,
                        endRangeSelectionColor: Colors.red,
                        rangeSelectionColor: Colors.red.shade100,
                        backgroundColor: Colors.white,
                      ),
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
                      selectionColor: Colors.white,
                      '${DateFormat('dd/MM/yyyy').format(selectedRange!.startDate!)}'
                          ' - '
                          '${DateFormat('dd/MM/yyyy').format(selectedRange!.endDate ?? selectedRange!.startDate!)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        onPressed: () {
                          if (selectedRange != null) {
                            Navigator.pop(context, selectedRange);
                          }
                        },
                        text: "Save",
                        backgroundColor: Colors.red,
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
