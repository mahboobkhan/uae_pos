import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../employee/employee_models.dart';
import '../../providers/desigination_provider.dart';
import '../../providers/designation_delete_provider.dart';
import '../../providers/update_designation.dart';
import 'calender.dart';
import 'custom_dialoges.dart';
import 'custom_fields.dart';

void EmployeeProfileDialog(
  BuildContext context,
  MapEntry<int, Employee> singleEmployee,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: EmployeProfile(singleEmployee: singleEmployee),
      );
    },
  );
}

class EmployeProfile extends StatefulWidget {
  MapEntry<int, Employee> singleEmployee; // Add any other parameters you need

  EmployeProfile({super.key, required this.singleEmployee});

  @override
  State<EmployeProfile> createState() => _EmployeProfileState();
}

class _EmployeProfileState extends State<EmployeProfile> {
  DateTime selectedDateTime = DateTime.now();
  final _contactNumber1 = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _contactNumber2Controller =
      TextEditingController();
  final TextEditingController _homeContactNumberController =
      TextEditingController();
  final TextEditingController _workPermitNumberController =
      TextEditingController();
  final TextEditingController _emiratesIdController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _physicalAddressController =
      TextEditingController();

  // Controllers for additional fields
  final TextEditingController _titleNameController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _ibanNumberController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailI2dController =
      TextEditingController(); // reuse if same as above
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _docNameController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _incrementController = TextEditingController();
  final TextEditingController _workingHoursController = TextEditingController();

  String? selectedJobType;
  String? selectedJobType2;
  String? selectedJobType3;
  String? selectedJobType4;

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  // Add separate controllers for each date field
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _contractExpiryController =
      TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();

    final singleEmployee = widget.singleEmployee;

    _employeeNameController.text =
        singleEmployee.value.employeeName.toString() ?? '';
    _emailIdController.text = singleEmployee.value.email.toString() ?? '';
    userId = widget.singleEmployee.value.userId.toString() ?? '';
  }

  /// ✅ Function should be OUTSIDE initState
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('user_id');

    print("📥 Loaded User ID from SharedPreferences: $id");

    setState(() {
      userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 950,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Title and dropdowns
                  Row(
                    children: [
                      const Text(
                        'Employee Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 180,
                        child: SmallDropdownField(
                          label: "Employee type",
                          options: ['Cleaning', 'Consultining', 'Reparing'],
                          selectedValue: selectedJobType3,
                          onChanged: (value) {
                            setState(() {
                              selectedJobType3 = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 180,
                        child: SmallDropdownField(
                          label: "Select Gender",
                          options: ['Male', 'Female', 'Other'],
                          selectedValue: selectedJobType4,
                          onChanged: (value) {
                            setState(() {
                              selectedJobType4 = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  // Right: Date and close icon
                  Row(
                    children: [
                      Text(
                        DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          final shouldClose = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.white,
                                  title: const Text("Are you sure?"),
                                  content: const Text(
                                    "Do you want to close this form? Unsaved changes may be lost.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text(
                                        "Keep Changes ",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldClose == true) {
                            Navigator.of(context).pop(); // close the dialog
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                userId != null ? "EID.EE/EH $userId" : "Loading...",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),

              // Fields
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomTextField(
                    label: "Employee Name",
                    hintText: "xyz",
                    controller: _employeeNameController,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdownField(
                        label: "Job Position",
                        options: ['Manager', 'Employee', 'Other'],
                        selectedValue:
                            selectedJobType, // ✅ Use local state, not provider
                        onChanged: (value) {
                          setState(() {
                            selectedJobType = value;
                          });
                          // ✅ Just store in provider (no rebuild trigger)
                          context.read<DesignationProvider>().setDesignation(
                            value!,
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      // 🔵 Update Button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.update),
                        label: const Text("Update"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          print("🔹 Update button pressed");

                          final selected =
                              context
                                  .read<DesignationProvider>()
                                  .selectedDesignation;
                          print("🔹 Selected designation: $selected");

                          if (selected == null || selected.isEmpty) {
                            print("❌ No designation selected");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please select a job position first",
                                ),
                              ),
                            );
                            return;
                          }

                          print("⏳ Calling update API...");
                          await context
                              .read<DesignationUpdateProvider>()
                              .updateDesignation(
                                DesignationUpdateRequest(
                                  id: 5, // Replace with actual user/employee ID
                                  newDesignations: selected,
                                ),
                              );

                          final provider =
                              context.read<DesignationUpdateProvider>();
                          print(
                            "📌 Provider state after update: ${provider.state}",
                          );

                          if (provider.state == RequestState.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Designation updated to $selected",
                                ),
                              ),
                            );
                          } else if (provider.state == RequestState.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  provider.errorMessage ?? "Update failed",
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 10),
                      // 🔴 Delete Button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          print("🗑 Delete button pressed");

                          final selected =
                              context
                                  .read<DesignationProvider>()
                                  .selectedDesignation;
                          print("🗑 Selected designation: $selected");

                          if (selected == null || selected.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please select a job position first",
                                ),
                              ),
                            );
                            return;
                          }

                          await context
                              .read<DesignationDeleteProvider>()
                              .deleteDesignation(
                                DesignationDeleteRequest(
                                  designations: selected,
                                ),
                              );

                          print("⏳ Calling delete API...");
                          await context
                              .read<DesignationDeleteProvider>()
                              .deleteDesignation(
                                DesignationDeleteRequest(
                                  designations: selected,
                                ),
                              );

                          final provider =
                              context.read<DesignationDeleteProvider>();
                          print(
                            "📌 Provider state after delete: ${provider.state}",
                          );

                          if (provider.state == RequestState.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Designation '$selected' deleted successfully",
                                ),
                              ),
                            );
                          } else if (provider.state == RequestState.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  provider.errorMessage ?? "Delete failed",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  CustomTextField(
                    label: "Contact Number",
                    hintText: "+971",
                    controller: _contactNumber1,
                  ),
                  CustomTextField(
                    label: "Contact No - 2",
                    hintText: "+971",
                    controller: _contactNumber2Controller,
                  ),
                  CustomTextField(
                    label: "Home Contact No",
                    hintText: "+971",
                    controller: _homeContactNumberController,
                  ),
                  CustomTextField(
                    label: "Work Permit No",
                    hintText: "+WP-1234",
                    controller: _workPermitNumberController,
                  ),
                  CustomTextField(
                    label: "Emirates ID",
                    hintText: "+12345",
                    controller: _emiratesIdController,
                  ),
                  CustomTextField(
                    label: "Email ID",
                    hintText: "abc@gmail.com",
                    controller: _emailIdController,
                  ),

                  CustomDateField(
                    label: "Date of Joining",
                    hintText: "dd-MM-yyyy",
                    controller: _joiningDateController,
                    // Use the dedicated controller
                    readOnly: true,
                    onTap: () => _pickJoiningDateCupertino(),
                  ),
                  CustomDateField(
                    label: "Work Contract Expiry",
                    hintText: "dd-MM-yyyy",
                    controller: _contractExpiryController,
                    // Use the dedicated controller
                    readOnly: true,
                    onTap:
                        _pickContractExpiryDate, // Use the dedicated function
                  ),
                  CustomDateField(
                    label: "Birthday",
                    hintText: "dd-MM-yyyy",
                    controller: _birthDateController,
                    // Use the dedicated controller
                    readOnly: true,
                    onTap: _pickBirthDate, // Use the dedicated function
                  ),
                  CustomTextField(
                    label: 'Salary',
                    hintText: 'AED-1000',
                    controller: _salaryController,
                  ),
                  CustomTextField(
                    label: 'Increment',
                    hintText: '10',
                    controller: _incrementController,
                  ),
                  CustomTextField(
                    label: 'Working Hours ',
                    hintText: '42',
                    controller: _workingHoursController,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Add More",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: 450,
                    child: CustomTextField(
                      label: "Physical Address",
                      hintText: "Address,house,street,town,post code",
                      controller: _physicalAddressController,
                    ),
                  ),
                  SizedBox(
                    width: 450,
                    child: CustomTextField(
                      label: "Note / Extra",
                      controller: _noteController,
                      hintText: 'xxxxx',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Bank Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomDropdownField(
                    label: "Select Bank",
                    options: ['Ubl', 'Hbl', 'Mezan', 'Cheque', 'Cash'],
                    selectedValue: selectedJobType2,
                    onChanged: (value) {
                      setState(() {
                        selectedJobType2 = value;
                      });
                    },
                  ),
                  CustomTextField(
                    label: "Title Name",
                    hintText: "xxxxxx",
                    controller: _titleNameController,
                  ),
                  CustomTextField(
                    label: "Bank Account",
                    hintText: "xxxxxxxxxx",
                    controller: _bankAccountController,
                  ),
                  CustomTextField(
                    label: "IBN Number",
                    hintText: "xxxxxxxxxxx",
                    controller: _ibanNumberController,
                  ),
                  CustomTextField(
                    label: "Contact Number",
                    hintText: "+971",
                    controller: _contactNumberController,
                  ),
                  CustomTextField(
                    label: "Email ID",
                    hintText: "@gmail.com",
                    controller: _emailI2dController,
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      InfoBox(
                        value: "Remaining Salary",
                        label: "AED-3000",
                        color: Colors.blue.shade50,
                      ),
                      InfoBox(
                        value: "Advance Payment",
                        label: "AED-3000",
                        color: Colors.blue.shade50,
                      ),
                      InfoBox(
                        value: "Bonuses",
                        label: "AED-3000",
                        color: Colors.blue.shade50,
                      ),
                      InfoBox(
                        value: "Fine Deductions",
                        label: "AED-3000",
                        color: Colors.blue.shade50,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          CustomCompactTextField(
                            label: 'Doc Name',
                            hintText: '',
                            controller: _docNameController,
                          ),
                          CustomDateNotificationField(
                            label: "Issue Date Notifications",
                            controller: _issueDateController,
                            readOnly: true,
                            hintText: "dd-MM-yyyy HH:mm",
                            onTap: _pickIssueDate,
                          ),
                          CustomDateNotificationField(
                            label: "Expiry Date Notifications",
                            controller: _expiryDateController,
                            readOnly: true,
                            hintText: "dd-MM-yyyy HH:mm",
                            onTap: _pickExpiryDate,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(150, 38),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // Optional: slight rounding
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.upload_file,
                                  size: 16,
                                  color: Colors.white,
                                ), //
                                SizedBox(width: 6),
                                Text(
                                  'Upload File',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ), //
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  CustomButton(
                    text: "Stop Contract",
                    backgroundColor: Colors.red,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: "Editing",
                    backgroundColor: Colors.blue,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: "Submit",
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      final provider = context.read<DesignationProvider>();

                      final selected =
                          provider.selectedDesignation?.trim() ?? "";
                      if (selected.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a job position first"),
                          ),
                        );
                        return;
                      }

                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getString("user_id") ?? "0";

                      final request = DesignationRequest(
                        userId: userId,
                        designations: selected,
                        createdBy: userId,
                      );

                      print(
                        "📦 Sending to API: ${jsonEncode(request.toJson())}",
                      );

                      await provider.createDesignation(request);

                      // ✅ Show correct API message immediately
                      if (provider.state == RequestState.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "✅ Designation '$selected' created successfully",
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "❌ ${provider.errorMessage ?? "Something went wrong"}",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickIssueDate() async {
    DateTime selectedDateTime = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: const Text('Select Date & Time'),
          content: CustomCupertinoCalendar(
            initialDateTime: selectedDateTime,
            onDateTimeChanged: (DateTime newDateTime) {
              selectedDateTime = newDateTime;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(selectedDateTime),
              child: const Text('Select', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ).then((pickedDateTime) {
      if (pickedDateTime != null && pickedDateTime is DateTime) {
        setState(() {
          _issueDateController.text =
              "${pickedDateTime.day}-${pickedDateTime.month}-${pickedDateTime.year} "
              "${pickedDateTime.hour.toString().padLeft(2, '0')}:${pickedDateTime.minute.toString().padLeft(2, '0')}";
        });
      }
    });
  }

  void _pickExpiryDate() async {
    DateTime selectedDateTime = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: const Text('Select Expiry Date & Time'),
          content: CustomCupertinoCalendar(
            initialDateTime: selectedDateTime,
            onDateTimeChanged: (DateTime newDateTime) {
              selectedDateTime = newDateTime;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(selectedDateTime),
              child: const Text('Select', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    ).then((pickedDateTime) {
      if (pickedDateTime != null && pickedDateTime is DateTime) {
        setState(() {
          _expiryDateController.text =
              "${pickedDateTime.day}-${pickedDateTime.month}-${pickedDateTime.year} "
              "${pickedDateTime.hour.toString().padLeft(2, '0')}:${pickedDateTime.minute.toString().padLeft(2, '0')}";
        });
      }
    });
  }

  void _pickContractExpiryDate() async {
    DateTime now = DateTime.now();
    DateTime selectedDate = DateTime(
      now.year,
      now.month,
      now.day,
    ); // Strip time

    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: const Text('Select Contract Expiry Date'),
          content: CustomCupertinoCalendar(
            initialDateTime: selectedDate,
            minimumDateTime: selectedDate,
            maximumDateTime: DateTime(2100),
            onDateTimeChanged: (DateTime newDate) {
              selectedDate = newDate;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(selectedDate),
              child: const Text('Select', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _contractExpiryController.text = DateFormat(
          'dd-MM-yyyy',
        ).format(pickedDate);
      });
    }
  }

  void _pickBirthDate() async {
    DateTime selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: const Text('Select Birth Date'),
          content: CustomCupertinoCalendar(
            initialDateTime: selectedDate,
            minimumDateTime: DateTime(1900),
            maximumDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              selectedDate = newDate;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(selectedDate),
              child: const Text('Select', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    ).then((pickedDate) {
      if (pickedDate != null && pickedDate is DateTime) {
        setState(() {
          _birthDateController.text = DateFormat(
            'dd-MM-yyyy',
          ).format(pickedDate);
        });
      }
    });
  }

  void _pickJoiningDateCupertino() async {
    DateTime now = DateTime.now();
    DateTime selectedDate = DateTime(
      now.year,
      now.month,
      now.day,
    ); // strip time

    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: Text('Joining Date'),
          content: CustomCupertinoCalendar(
            initialDateTime: selectedDate,
            minimumDateTime: DateTime(1900),
            maximumDateTime: DateTime(2100),
            onDateTimeChanged: (DateTime newDate) {
              selectedDate = newDate;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(selectedDate),
              child: const Text('Select', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _joiningDateController.text = DateFormat(
          'dd-MM-yyyy',
        ).format(pickedDate);
      });
    }
  }
}

class SuccessDialog extends StatelessWidget {
  final String message;

  const SuccessDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Success', style: TextStyle(color: Colors.green)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error', style: TextStyle(color: Colors.red)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
