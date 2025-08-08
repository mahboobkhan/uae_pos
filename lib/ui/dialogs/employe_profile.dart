import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../employee/AllEmployeeData.dart';
import '../../employee/employee_models.dart';
import '../../providers/create_bank_account.dart';
import '../../providers/desigination_provider.dart';
import '../../providers/update_ban_account_provider.dart';
import 'calender.dart';
import 'custom_dialoges.dart';
import 'custom_fields.dart';

void EmployeeProfileDialog(BuildContext context,
    MapEntry<int, Employee> singleEmployee,
    AllEmployeeData? data,) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: EmployeProfile(data: data, singleEmployee: singleEmployee),
      );
    },
  );
}

class EmployeProfile extends StatefulWidget {
  MapEntry<int, Employee> singleEmployee; // Add any other parameters you need
  AllEmployeeData? data;

  EmployeProfile({super.key, required this.singleEmployee, required this.data});

  @override
  State<EmployeProfile> createState() => _EmployeProfileState();
}

class _EmployeProfileState extends State<EmployeProfile> {
  DateTime selectedDateTime = DateTime.now();
  final _contactNumber1 = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final _contactNumber2Controller = TextEditingController();
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
  final List<String> jobTypeOptions = ['Cleaning', 'Consultining', 'Reparing'];
  final List<String> jobPositionOptions = ['Manager', 'Employee', 'Other'];

  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  // Add separate controllers for each date field
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _contractExpiryController =
  TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  TextEditingController _eidController = TextEditingController();
  final genderOptions = ["Male", "Female"];
  String? selectedGender;
  String? selectedJobType3;
  final employeeType = ["Employee", "Manager"];

  @override
  void initState() {
    super.initState();

    final singleEmployee = widget.singleEmployee;

    _employeeNameController.text =
        singleEmployee.value.employeeName.toString() ?? '';
    _emailIdController.text = singleEmployee.value.email.toString() ?? '';
    _eidController.text = singleEmployee.value.userId.toString() ?? '';
    final incomingType = widget.singleEmployee.value.employeeType.trim();
    final allTypes =
    widget.singleEmployee.value.allEmployeeTypes
        .map((d) => d.employeeType)
        .toList();
    selectedJobType3 =
    allTypes.contains(incomingType)
        ? incomingType
        : allTypes.isNotEmpty
        ? allTypes
        .first // fallback to first valid option
        : null;

    final incomingGender = singleEmployee.value.gender.trim();
    selectedGender =
    genderOptions.contains(incomingGender)
        ? incomingGender
        : genderOptions.first;
    final incomingPosition = singleEmployee.value.empDesignation.trim();
    selectedJobType =
    singleEmployee.value.allDesignations
        .map((d) => d.designations)
        .toList()
        .contains(incomingPosition)
        ? incomingPosition
        : "Manager";

    _contactNumber1.text = singleEmployee.value.homePhone.toString() ?? '';
    _contactNumber2Controller.text =
        singleEmployee.value.homePhone.toString() ?? '';
    _homeContactNumberController.text =
        singleEmployee.value.homePhone.toString() ?? '';
    _workPermitNumberController.text =
        singleEmployee.value.workPermitNumber.toString() ?? '';
    _emiratesIdController.text =
        singleEmployee.value.emirateId.toString() ?? '';
    _joiningDateController.text =
        singleEmployee.value.joiningDate.toString() ?? '';
    _contractExpiryController.text =
        singleEmployee.value.contractExpiryDate.toString() ?? '';
    _birthDateController.text =
        singleEmployee.value.dateOfBirth.toString() ?? '';
    _salaryController.text = singleEmployee.value.salary.toString() ?? '';
    _incrementController.text =
        singleEmployee.value.incrementAmount.toString() ?? '';
    _workingHoursController.text =
        singleEmployee.value.workingHours.toString() ?? '';
    _physicalAddressController.text =
        singleEmployee.value.physicalAddress.toString() ?? '';
    _noteController.text = singleEmployee.value.extraNote1.toString() ?? '';
    // _titleNameController.text = bankAccount.value.titleName;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer2<
          UpdateUserBankAccountProvider,
          CreateUserBankAccountProvider>(
        builder: (ctx, updateUserBankAccountProvider,
            createUserBankAccountProvider, _) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
                                options:
                                widget.singleEmployee.value.allEmployeeTypes
                                    .map((d) => d.employeeType)
                                    .toList(),
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
                                options: genderOptions, // fixed list
                                selectedValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
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
                                /* final shouldClose = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: const Text("Are you sure?"),
                                        content: const Text(
                                          "Do you want to close this form? Unsaved changes may be lost.",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                            child: const Text(
                                              "Keep Changes ",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(true),
                                            child: const Text(
                                              "Close",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                if (shouldClose == true) {
                                  Navigator.of(
                                    context,
                                  ).pop(); // close the dialog
                                }*/
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(_eidController.text, style: TextStyle(fontSize: 12)),
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
                              options:
                              widget.singleEmployee.value.allDesignations
                                  .map((d) => d.designations)
                                  .toList(),
                              selectedValue: selectedJobType,
                              onChanged: (value) {
                                setState(() {
                                  selectedJobType = value;
                                });
                                // ✅ Update provider value
                                context
                                    .read<DesignationProvider>()
                                    .setDesignation(value!);
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        CustomDropdownField(
                          label: "Select Bank",
                          options:
                          widget.data!.allBanks
                              .map((d) => d.bankName.trim())
                              .toList(),
                          selectedValue: null,
                          onChanged: (value) {
                            setState(() {
                              //   selectedJobType2 = value;
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
                            //  Navigator.of(context).pop(true);
                              updateUserBankAccountProvider.updateBankAccount(
                              UpdateUserBankAccountRequest(
                                userId: widget.singleEmployee.value.userId,
                                bankAccountNumber: 'yahya',
                                bankName: _titleNameController.text,
                                branchCode: 'N/A',
                                bankAddress: 'N/A',
                                titleName: '',
                                ibanNumber: '',
                                contactNumber: '',
                                emailId: '',
                                additionalNote: 'N/A',
                              ),
                            );
                               Navigator.of(context).pop(true);

                           /* createUserBankAccountProvider.createBankAccount(
                              CreateUserBankAccountRequest(
                                userId: widget.singleEmployee.value.userId,
                                bankName:  "N/A",
                                branchCode:  "N/A",
                                bankAddress: "N/A",
                                titleName: _titleNameController.text.trim(),
                                bankAccountNumber: _bankAccountController.text.trim(),
                                ibanNumber: _ibanNumberController.text.trim(),
                                contactNumber: _contactNumberController.text.trim(),
                                emailId: _emailI2dController.text.trim(),
                                additionalNote: _noteController.text.trim(),
                                createdBy: "N/A", // whoever is logged in
                              ),
                            );*/
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
          "${pickedDateTime.day}-${pickedDateTime.month}-${pickedDateTime
              .year} "
              "${pickedDateTime.hour.toString().padLeft(
              2, '0')}:${pickedDateTime.minute.toString().padLeft(2, '0')}";
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
          "${pickedDateTime.day}-${pickedDateTime.month}-${pickedDateTime
              .year} "
              "${pickedDateTime.hour.toString().padLeft(
              2, '0')}:${pickedDateTime.minute.toString().padLeft(2, '0')}";
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
