import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:provider/provider.dart';

import '../../employee/employee_models.dart';
import '../../providers/signup_provider.dart';
import '../screens/login screens/log_screen.dart';

class CustomTextField extends StatefulWidget {

  final String label;
  final String hintText;
  final TextEditingController controller;
  final double width;
  final bool enabled;
  final bool readOnly;
  final bool isPassword;
  final Widget? suffixIcon;
  // 🔹 new parameters
  final int? maxLength;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;


  const CustomTextField({
    super.key,
    required this.label,
    this.readOnly = false,
    required this.hintText,
    required this.controller,
    this.width = 220,
    this.enabled = true,
    this.isPassword = false,
    this.suffixIcon,
    this.maxLength,
    this.keyboardType = TextInputType.text,  // default
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,

      child: TextField(
        cursorColor: Colors.black,
        controller: widget.controller,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          suffixIcon:
              widget.suffixIcon ??
              (widget.isPassword
                  ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                  : null),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final double width;
  final double height;
  final bool enabled;

  const CustomDropdownField({
    super.key,
    required this.label,
    this.enabled = true,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.width = 220,
    this.height = 41, // Similar to default form field height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: IgnorePointer(
        ignoring: !enabled, // disable taps when false
        child: CustomDropdown<String>(
          hintText: label,
          items: options,
          initialItem: (selectedValue != null && options.contains(selectedValue))
              ? selectedValue
              : null,          closedHeaderPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11.8,
          ),
          decoration: CustomDropdownDecoration(
            closedBorder: Border.all(color: Colors.grey),
            closedBorderRadius: BorderRadius.circular(4),
            expandedBorder: Border.all(color: Colors.red, width: 1),
            expandedBorderRadius: BorderRadius.circular(4),
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            listItemStyle: const TextStyle(fontSize: 16, color: Colors.black),
            closedFillColor: Colors.white,
          ),
          onChanged: (value) => onChanged(value),
        ),
      ),
    );
  }
}

class CustomDropdownWithSearch extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final double width;
  final double height;

  const CustomDropdownWithSearch({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.width = 220,
    this.height = 41,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child:
          options.length > 4
              ? CustomDropdown.search(
                hintText: label,
                items: options,
                initialItem: selectedValue,
                closedHeaderPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11.8,
                ),
                decoration: CustomDropdownDecoration(
                  closedBorder: Border.all(color: Colors.grey),
                  closedBorderRadius: BorderRadius.circular(4),
                  expandedBorder: Border.all(color: Colors.red, width: 1),
                  expandedBorderRadius: BorderRadius.circular(4),
                  hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                  listItemStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  closedFillColor: Colors.white,
                ),
                onChanged: (value) => onChanged(value),
              )
              : CustomDropdown<String>(
                hintText: label,
                items: options,
                initialItem: selectedValue,
                closedHeaderPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11.8,
                ),
                decoration: CustomDropdownDecoration(
                  closedBorder: Border.all(color: Colors.grey),
                  closedBorderRadius: BorderRadius.circular(4),
                  expandedBorder: Border.all(color: Colors.red, width: 1),
                  expandedBorderRadius: BorderRadius.circular(4),
                  hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                  listItemStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  closedFillColor: Colors.white,
                ),
                onChanged: (value) => onChanged(value),
              ),
    );
  }
}

class CustomDropdownWithRightAdd extends StatelessWidget {
  final String label;
  final String? value;
  final List<Designation> items;
  final ValueChanged<String?> onChanged;
  final VoidCallback onAddPressed;
  final double? width;

  const CustomDropdownWithRightAdd({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.onAddPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Outer border
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Row(
        children: [
          /// Expanded dropdown without border
          Expanded(
            child:
                items.length > 4
                    ? CustomDropdown.search(
                      hintText: label,
                      initialItem: value,
                      items: items.map((e) => e.designations).toList(),
                      closedHeaderPadding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 11.8,
                      ),
                      decoration: const CustomDropdownDecoration(
                        closedBorder: Border.fromBorderSide(
                          BorderSide.none,
                        ), // No border
                        expandedBorder: Border.fromBorderSide(BorderSide.none),
                        closedBorderRadius: BorderRadius.zero,
                        expandedBorderRadius: BorderRadius.zero,
                        closedFillColor:
                            Colors.white, // transparent so container shows
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                        listItemStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      onChanged: onChanged,
                    )
                    : CustomDropdown<String>(
                      hintText: label,
                      initialItem: value,
                      items: items.map((e) => e.designations).toList(),
                      closedHeaderPadding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 11.8,
                      ),
                      decoration: const CustomDropdownDecoration(
                        closedBorder: Border.fromBorderSide(
                          BorderSide.none,
                        ), // No border
                        expandedBorder: Border.fromBorderSide(BorderSide.none),
                        closedBorderRadius: BorderRadius.zero,
                        expandedBorderRadius: BorderRadius.zero,
                        closedFillColor:
                            Colors.white, // transparent so container shows
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                        listItemStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      onChanged: onChanged,
                    ),
          ),
          const SizedBox(width: 8),

          /// Plus (+) icon on the right
          GestureDetector(
            onTap: onAddPressed,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: const Icon(Icons.add, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField1 extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final double? width;

  const CustomTextField1({
    super.key,
    required this.label,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Agar null ho to parent width use karega
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        onChanged: onChanged,
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color; // single required color

  const InfoBox({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 48.5,
      child: Container(
        decoration: BoxDecoration(
          color: color, // light blue fill
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey), // grey border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class InstituteManagementDialog extends StatefulWidget {
  const InstituteManagementDialog({super.key});

  @override
  State<InstituteManagementDialog> createState() =>
      _InstituteManagementDialogState();
}

class _InstituteManagementDialogState extends State<InstituteManagementDialog> {
  final List<String> institutes = [];
  final TextEditingController addController = TextEditingController();
  final TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(12),
      insetPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: 363,
        height: 305,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Institutes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 25, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Add input field and button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: addController,
                      cursorColor: Colors.blue,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: "Add institute...",
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      if (addController.text.trim().isNotEmpty) {
                        setState(() {
                          institutes.add(addController.text.trim());
                          addController.clear();
                        });
                      }
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // List
            Expanded(
              child:
                  institutes.isEmpty
                      ? const Center(
                        child: Text(
                          'No institutes',
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                      : ListView.builder(
                        itemCount: institutes.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ListTile(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              title: Text(
                                institutes[index],
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: SizedBox(
                                width: 80,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        final updated =
                                            await showDialog<String>(
                                              context: context,
                                              builder:
                                                  (_) => EditInstituteDialog(
                                                    initialValue:
                                                        institutes[index],
                                                  ),
                                            );

                                        if (updated != null &&
                                            updated.trim().isNotEmpty) {
                                          setState(() {
                                            institutes[index] = updated.trim();
                                          });
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        setState(() {
                                          institutes.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditInstituteDialog extends StatefulWidget {
  final String initialValue;

  const EditInstituteDialog({super.key, required this.initialValue});

  @override
  State<EditInstituteDialog> createState() => _EditInstituteDialogState();
}

class _EditInstituteDialogState extends State<EditInstituteDialog> {
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              cursorColor: Colors.blue,
              controller: _editController,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: Colors.grey),
                ),
                labelText: 'Edit institute',
                labelStyle: TextStyle(color: Colors.blue),
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_editController.text.trim().isNotEmpty) {
                      Navigator.pop(context, _editController.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoBoxNoColor extends StatelessWidget {
  final String label;
  final String value;

  const InfoBoxNoColor({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 49,
      child: Container(
        decoration: BoxDecoration(
          // No background color
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey), // grey border remains
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class SmallDropdownField extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> options;
  final bool enabled;
  final ValueChanged<String?> onChanged;
  final double width;

  const SmallDropdownField({
    super.key,
    required this.label,
    this.enabled =true,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.width = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: IgnorePointer(
        ignoring: !enabled,
        child: CustomDropdown<String>(
          hintText: label, // works like labelText in small mode
          items: options,
          initialItem: (selectedValue != null && options.contains(selectedValue))
              ? selectedValue
              : null,          closedHeaderPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: .8,
          ),
          decoration: CustomDropdownDecoration(
            closedBorder: Border.all(color: Colors.grey,width: 00.1),
            closedBorderRadius: BorderRadius.circular(4),
            expandedBorder: Border.all(color: Colors.red, width: 1),
            expandedBorderRadius: BorderRadius.circular(4),
            closedFillColor: Colors.white,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            listItemStyle: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class DateTimePickerExample extends StatefulWidget {
  const DateTimePickerExample({Key? key}) : super(key: key);

  @override
  State<DateTimePickerExample> createState() => _DateTimePickerExampleState();
}

class _DateTimePickerExampleState extends State<DateTimePickerExample> {
  DateTime selectedDateTime = DateTime.now();

  Future<void> _selectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            textTheme: const TextTheme(
              headlineSmall: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              titleSmall: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              bodyLarge: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.red,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // dialogTheme: DialogTheme(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              // ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Widget buildDateTimeField({
    required String label,
    required DateTime selectedDateTime,
    required VoidCallback onTap,
    IconData icon = Icons.calendar_month_outlined,
    String dateFormat = "dd-MM-yyyy - hh:mm a",
  }) {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            border: const OutlineInputBorder(),
            suffixIcon: Icon(icon, color: Colors.red, size: 22),
          ),
          child: Text(
            DateFormat(dateFormat).format(selectedDateTime),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DateTime Picker")),
      body: Center(
        child: buildDateTimeField(
          label: "Select Date & Time",
          selectedDateTime: selectedDateTime,
          onTap: _selectDateTime,
        ),
      ),
    );
  }
}

class CustomDateField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final double width;
  final VoidCallback onTap;
  final bool readOnly;
  final bool enabled;


  const CustomDateField({
    Key? key,
    required this.label,
    required this.hintText,
    this.enabled = true,
    required this.controller,
    required this.onTap,
    this.width = 220,
    this.readOnly = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          suffixIcon: const Icon(
            Icons.calendar_month,
            color: Colors.red,
            size: 20,
          ),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}

class CustomDateNotificationField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final double width;
  final VoidCallback onTap;
  final bool readOnly;

  const CustomDateNotificationField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.onTap,
    this.width = 150, // ⬅️ Reduced default width
    this.readOnly = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 30, // ⬅️ Compact height
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ), // ⬅️ Shrinks field height
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          suffixIcon: const Icon(
            Icons.alarm_on_sharp,
            color: Colors.red,
            size: 20,
          ),
        ),
        style: const TextStyle(
          fontSize: 10,
          color: Colors.black,
        ), // ⬅️ Slightly smaller font
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final double width;

  const SearchTextField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
    this.width = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: const Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;

  const ConfirmationDialog({
    Key? key,
    this.title = 'Are you sure?',
    this.content = 'Do you really want to close? Unsaved changes may be lost.',
    this.cancelText = 'Cancel',
    this.confirmText = 'Close',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText, style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText, style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class CustomCompactTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final double width;
  final bool enabled;

  const CustomCompactTextField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.width = 150, // Compact width
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 30, // Compact height
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
        style: const TextStyle(fontSize: 10, color: Colors.black),
      ),
    );
  }
}

// logout button
class HoverLogoutButton extends StatefulWidget {
  final double width;
  final double height;
  final double iconSize;
  final Color defaultColor;
  final Color hoverColor;
  final VoidCallback? onTap;

  const HoverLogoutButton({
    super.key,
    this.width = 50,
    this.height = 50,
    this.iconSize = 28,
    this.defaultColor = Colors.red,
    this.hoverColor = Colors.redAccent,
    this.onTap,
  });

  @override
  State<HoverLogoutButton> createState() => _HoverLogoutButtonState();
}

class _HoverLogoutButtonState extends State<HoverLogoutButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap:
            widget.onTap ??
            () async {
              // Clear all stored data before logging out
              final signupProvider = Provider.of<SignupProvider>(
                context,
                listen: false,
              );
              await signupProvider.logout();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LogScreen()),
              );
            },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            child: Icon(
              Icons.power_settings_new,
              color: isHovered ? widget.hoverColor : widget.defaultColor,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
