import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_dialoges.dart';
import 'custom_fields.dart';

void EmployeeProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child:  EmployeProfile(),
      );
    },
  );
}

class EmployeProfile extends StatefulWidget {
  const EmployeProfile({super.key});

  @override
  State<EmployeProfile> createState() => _EmployeProfileState();
}

class _EmployeProfileState extends State<EmployeProfile> {
  DateTime selectedDateTime = DateTime.now();
  final _contactNumber1 = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _contactNumber1Controller =
      TextEditingController();
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

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _dateTimeController.text = DateFormat(
          'dd-MM-yyyy – hh:mm a',
        ).format(combined);
      }
    }
  }

  Future<void> _pickDateTime2() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        final formatted = DateFormat('dd-MM-yyyy – hh:mm a').format(combined);
        _expiryDateController.text = formatted;
        _issueDateController.text = formatted;
      }
    }
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
                        width: 160,
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
                        width: 160,
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
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text("Are you sure?"),
                              content: const Text("Do you want to close this form? Unsaved changes may be lost."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Keep Changes ",style: TextStyle(color:Colors.blue ),),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("Close",style: TextStyle(color:Colors.red ),),
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
                'EID.EE/EH 10110', // Static example ID
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                  CustomDropdownField(
                    label: "Job Position",
                    options: ['Manager', 'Employee', 'Other'],
                    selectedValue: selectedJobType,
                    onChanged: (value) {
                      setState(() {
                        selectedJobType = value;
                      });
                    },
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
                    controller: _dateTimeController,
                    readOnly: true,
                    onTap: _pickDateTime,
                  ),
                  CustomDateField(
                    label: "Work Contract Expiry",
                    controller: _dateTimeController,
                    hintText: "dd-MM-yyyy",
                    readOnly: true,
                    onTap: _pickDateTime,
                  ),
                  CustomDateField(
                    label: "Birthday",
                    controller: _dateTimeController,
                    hintText: "dd-MM-yyyy",
                    readOnly: true,
                    onTap: _pickDateTime,
                  ),
                  SizedBox(
                    width: 180,
                    child: CustomTextField(
                      label: 'Salary',
                      hintText: 'AED-1000',
                      controller: _salaryController,
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: CustomTextField(
                      label: 'Increment',
                      hintText: '10',
                      controller: _incrementController,
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: CustomTextField(
                      label: 'Working Hours ',
                      hintText: '42',
                      controller: _workingHoursController,
                    ),
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
              SizedBox(height: 10,),
              Wrap(spacing: 10,
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
              ],),
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
                    options: ['ubl', 'Hbl', 'Mezan'],
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
                  CustomTextField(
                    label: 'Doc Name',
                    hintText: 'xxxxx',
                    controller: _docNameController,
                  ),

                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
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
                      InfoBox(
                        value: "Show Payments",
                        label: "AED-3000",
                        color: Colors.blue.shade50,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
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
                    onPressed: () {},
                  ),
                  Spacer(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      CustomDateNotificationField(
                        label: "Issue Date Notifications",
                        controller: _issueDateController,
                        readOnly: true,
                        hintText: "dd-MM-yyyy HH:mm",
                        onTap: _pickDateTime2,
                      ),
                      CustomDateNotificationField(
                        label: "Expiry Date Notifications",
                        controller: _expiryDateController,
                        readOnly: true,
                        hintText: "dd-MM-yyyy HH:mm",
                        onTap: _pickDateTime2,
                      ),

                      ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(100, 30),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
        ),
      ),
    );
  }
}
