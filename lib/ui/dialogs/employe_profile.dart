import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../employee/AllEmployeeData.dart';
import '../../employee/EmployeeProvider.dart';
import '../../employee/employee_models.dart';
import '../../providers/create_bank_account.dart';
import '../../providers/signup_provider.dart';
import '../../providers/update_ban_account_provider.dart';
import '../../utils/request_state.dart';
import 'calender.dart';
import 'custom_dialoges.dart';
import 'custom_fields.dart';

Future<Map<String, dynamic>?> EmployeeProfileDialog(
  BuildContext context,
  MapEntry<int, Employee> singleEmployee,
  AllEmployeeData? data,
) {
  return showDialog<Map<String, dynamic>?>(
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
  final MapEntry<int, Employee>
  singleEmployee; // Add any other parameters you need
  final AllEmployeeData? data;

  const EmployeProfile({
    super.key,
    required this.singleEmployee,
    required this.data,
  });

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
  String? _selectedBank;

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

  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  // Add separate controllers for each date field
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _contractExpiryController =
      TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  TextEditingController _eidController = TextEditingController();

  final genderOptions = ["Male", "Female"]; // ok
  String? selectedGender; //ok

  String? employeeTypeSelected;

  @override
  void initState() {
    super.initState();

    // Add listener to refresh form when employee data changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeProvider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );
      employeeProvider.addListener(_onEmployeeDataChanged);

      // Ensure we have the latest data when dialog opens
      _ensureLatestData();
    });

    final singleEmployee = widget.singleEmployee;

    // Initialize form with current employee data
    _initializeFormData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer4<
        UpdateUserBankAccountProvider,
        CreateUserBankAccountProvider,
        EmployeeProvider,
        SignupProvider
      >(
        builder: (
          ctx,
          updateUserBankAccountProvider,
          createUserBankAccountProvider,
          employeeProvider,
          signupProvider,
          _,
        ) {
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
                                selectedValue: employeeTypeSelected,
                                onChanged: (value) {
                                  setState(() {
                                    employeeTypeSelected = value;
                                  });
                                  print("Selected Employee Typesss: $value");
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getLastUpdatedText(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
                                print("Selected Employee 2: $value");
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
                          selectedValue: _selectedBank,
                          onChanged: (value) {
                            setState(() {
                              _selectedBank = value;
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
                              label:
                                  widget
                                              .singleEmployee
                                              .value
                                              .salaryCurrentMonth
                                              ?.remainingSalary !=
                                          null
                                      ? "AED-${widget.singleEmployee.value.salaryCurrentMonth!.remainingSalary}"
                                      : "AED-0",
                              color: Colors.blue.shade50,
                            ),
                            InfoBox(
                              value: "Advance Payment",
                              label:
                                  widget
                                              .singleEmployee
                                              .value
                                              .salaryCurrentMonth
                                              ?.advanceSalary !=
                                          null
                                      ? "AED-${widget.singleEmployee.value.salaryCurrentMonth!.advanceSalary}"
                                      : "AED-0",
                              color: Colors.blue.shade50,
                            ),
                            InfoBox(
                              value: "Total Salary",
                              label:
                                  widget
                                              .singleEmployee
                                              .value
                                              .salaryCurrentMonth
                                              ?.totalSalary !=
                                          null
                                      ? "AED-${widget.singleEmployee.value.salaryCurrentMonth!.totalSalary}"
                                      : "AED-0",
                              color: Colors.blue.shade50,
                            ),
                            InfoBox(
                              value: "Base Salary",
                              label:
                                  widget.singleEmployee.value.salary != null
                                      ? "AED-${widget.singleEmployee.value.salary}"
                                      : "AED-0",
                              color: Colors.blue.shade50,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(height: 10),
                            /*
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
*/
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
                            final String currentUserId =
                                widget.singleEmployee.value.userId;
                            final String enteredAccountNumber =
                                _bankAccountController.text.trim();

                            // First: update employee profile fields
                            final profilePayload = <String, dynamic>{
                              'user_id': widget.singleEmployee.value.userId,
                              'employee_name':
                                  _employeeNameController.text.trim(),
                              'email': _emailIdController.text.trim(),
                              'home_phone': _contactNumber1.text.trim(),
                              'alternate_phone':
                                  _contactNumber2Controller.text.trim(),
                              'personal_phone':
                                  _homeContactNumberController.text.trim(),
                              'work_permit_number':
                                  _workPermitNumberController.text.trim(),
                              'emirate_id': _emiratesIdController.text.trim(),
                              'joining_date':
                                  _joiningDateController.text.trim(),
                              'contract_expiry_date':
                                  _contractExpiryController.text.trim(),
                              'date_of_birth': _birthDateController.text.trim(),
                              'physical_address':
                                  _physicalAddressController.text.trim(),
                              'extra_note_1': _noteController.text.trim(),
                              'gender': selectedGender ?? '',
                              'emp_designation': selectedJobType ?? '',
                              'employee_type': employeeTypeSelected ?? '',
                              'salary': _salaryController.text.trim(),
                              'increment_amount':
                                  _incrementController.text.trim(),
                              'working_hours':
                                  _workingHoursController.text.trim(),
                            };
                            print("Payload: $profilePayload");
                            final profileRes = await signupProvider
                                .updateEmployeeProfile(profilePayload);
                            if (profileRes['success'] != true) {
                              _showMessage(
                                context,
                                profileRes['message'] ??
                                    'Profile update failed',
                              );
                              return;
                            }

                            // Then: bank account update using current user id
                           /* final List<BankAccount> accountsForUser =
                                (employeeProvider.allUserBankAccounts ?? [])
                                    .where((a) => a.userId == currentUserId)
                                    .toList();

                            if (accountsForUser.isEmpty) {
                              _showMessage(
                                context,
                                "No existing bank account found to update",
                              );
                              return;
                            }*/

                       /*     await updateUserBankAccountProvider
                                .updateBankAccount(
                                  UpdateUserBankAccountRequest(
                                    userId: currentUserId,
                                    bankName: _selectedBank ?? "N/A",
                                    branchCode: "N/A",
                                    bankAddress: "N/A",
                                    titleName: _titleNameController.text.trim(),
                                    bankAccountNumber: enteredAccountNumber,
                                    ibanNumber:
                                        _ibanNumberController.text.trim(),
                                    contactNumber:
                                        _contactNumberController.text.trim(),
                                    emailId: _emailI2dController.text.trim(),
                                    additionalNote: _noteController.text.trim(),
                                  ),
                                );
*/
                            if (updateUserBankAccountProvider.state ==
                                RequestState.success) {
                              await employeeProvider.getFullData();

                              // Repopulate profile controllers from server
                              final updatedEmp = employeeProvider.employees
                                  ?.firstWhere(
                                    (e) => e.userId == currentUserId,
                                    orElse: () => null as dynamic,
                                  );
                              if (updatedEmp != null) {
                                setState(() {
                                  _employeeNameController.text =
                                      updatedEmp.employeeName;
                                  _emailIdController.text = updatedEmp.email;
                                  _contactNumber1.text = updatedEmp.homePhone;
                                  _contactNumber2Controller.text =
                                      updatedEmp.alternatePhone;
                                  _homeContactNumberController.text =
                                      updatedEmp.personalPhone;
                                  _workPermitNumberController.text =
                                      updatedEmp.workPermitNumber;
                                  _emiratesIdController.text =
                                      updatedEmp.emirateId;
                                  _joiningDateController.text =
                                      updatedEmp.joiningDate;
                                  _contractExpiryController.text =
                                      updatedEmp.contractExpiryDate;
                                  _birthDateController.text =
                                      updatedEmp.dateOfBirth;
                                  _physicalAddressController.text =
                                      updatedEmp.physicalAddress;
                                  _noteController.text = updatedEmp.extraNote1;

                                  selectedGender = updatedEmp.gender;

                                  // Update employee type selection
                                 /* final updatedEmployeeType =
                                      updatedEmp.employeeType.trim();
                                  if (updatedEmployeeType.isNotEmpty) {
                                    final availableTypes =
                                        updatedEmp.allEmployeeTypes
                                            .map((d) => d.employeeType)
                                            .toList();

                                    if (availableTypes.contains(
                                      updatedEmployeeType,
                                    )) {
                                      employeeTypeSelected =
                                          updatedEmployeeType;
                                    } else {
                                      // Try to find a match
                                      final matchedType = availableTypes
                                          .firstWhere(
                                            (type) =>
                                                type.toLowerCase() ==
                                                updatedEmployeeType
                                                    .toLowerCase(),
                                            orElse:
                                                () =>
                                                    availableTypes.isNotEmpty
                                                        ? availableTypes.first
                                                        : '',
                                          );
                                      employeeTypeSelected =
                                          matchedType.isNotEmpty
                                              ? matchedType
                                              : null;
                                    }
                                  } else {
                                    employeeTypeSelected = null;
                                  }*/

                                  // Update job type selection
                                 /* final updatedJobType =
                                      updatedEmp.empDesignation.trim();
                                  if (updatedJobType.isNotEmpty) {
                                    final availableDesignations =
                                        updatedEmp.allDesignations
                                            .map((d) => d.designations)
                                            .toList();

                                    if (availableDesignations.contains(
                                      updatedJobType,
                                    )) {
                                      selectedJobType = updatedJobType;
                                    } else {
                                      // Try to find a match
                                      final matchedDesignation =
                                          availableDesignations.firstWhere(
                                            (designation) =>
                                                designation.toLowerCase() ==
                                                updatedJobType.toLowerCase(),
                                            orElse:
                                                () =>
                                                    availableDesignations
                                                            .isNotEmpty
                                                        ? availableDesignations
                                                            .first
                                                        : '',
                                          );
                                      selectedJobType =
                                          matchedDesignation.isNotEmpty
                                              ? matchedDesignation
                                              : null;
                                    }
                                  } else {
                                    selectedJobType = null;
                                  }*/
                                  /*final updatedEmp = widget.em.firstWhere(
                                        (emp) => emp.id == currentEmployeeId,
                                    orElse: () => EmployeeModel.empty(), // your empty model
                                  );*/
                                  /*_salaryController.text =
                                      (updatedEmp.salary ?? '').toString();
                                  _incrementController.text =
                                      updatedEmp.incrementAmount;
                                  _workingHoursController.text =
                                      updatedEmp.workingHours;*/
                                });
                              }

                              /* _showMessage(
                                context,
                                "Profile and bank account updated successfully",
                              );
                              // Update the last updated date to current time since we just updated the profile
                              setState(() {
                                // Trigger a rebuild to show the updated last updated date
                              });
                              // Ensure form state is properly updated after successful submission
                              await _handleFormSubmission();
                            } else {
                              _showMessage(
                                context,
                                updateUserBankAccountProvider.errorMessage ??
                                    "Update failed",
                              );
                            }
                          },*/
                            }
                          },
                        ),
                        // Removed duplicate Submit button with invalid code
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

  @override
  void dispose() {
    final employeeProvider = Provider.of<EmployeeProvider>(
      context,
      listen: false,
    );
    employeeProvider.removeListener(_onEmployeeDataChanged);
    super.dispose();
  }

  void _onEmployeeDataChanged() {
    if (mounted) {
      setState(() {
        _refreshFormData();
      });
    }
  }

  // Method to refresh form when dialog is reopened
  void _refreshFormOnReopen() {
    if (mounted) {
      setState(() {
        _ensureLatestData();
      });
    }
  }

  // Override didChangeDependencies to refresh form when dependencies change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh form data when dependencies change (e.g., when dialog is reopened)
    _refreshFormOnReopen();
  }

  // Method to handle form submission and ensure proper state update
  Future<void> _handleFormSubmission() async {
    // This method will be called after successful form submission
    // to ensure the form state is properly updated
    await _ensureLatestData();
  }

  // Method to get the last updated date text with proper error handling
  String _getLastUpdatedText() {
    try {
      final lastUpdatedDate = widget.singleEmployee.value.lastUpdatedDate;
      if (lastUpdatedDate.isNotEmpty) {
        final parsedDate = DateTime.parse(lastUpdatedDate);
        return "Last Updated: ${DateFormat('dd-MM-yyyy').format(parsedDate)}";
      } else {
        return "Last Updated: Not available";
      }
    } catch (e) {
      // If date parsing fails, show the raw string or fallback
      final lastUpdatedDate = widget.singleEmployee.value.lastUpdatedDate;
      if (lastUpdatedDate.isNotEmpty) {
        return "Last Updated: $lastUpdatedDate";
      } else {
        return "Last Updated: Not available";
      }
    }
  }

  // Method to get the current editing time

  // Method to refresh form data from the latest server data
  Future<void> _refreshEmployeeDataFromServer() async {
    try {
      final employeeProvider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );
      await employeeProvider.getFullData();

      // After refreshing data, update the form with the latest data
      if (mounted) {
        setState(() {
          _initializeFormData();
        });
      }
    } catch (e) {
      print('Error refreshing employee data: $e');
    }
  }

  // Method to ensure form shows the latest data when dialog is reopened
  Future<void> _ensureLatestData() async {
    try {
      final employeeProvider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );

      // Check if we need to refresh the data
      if (employeeProvider.data == null || employeeProvider.employees == null) {
        await _refreshEmployeeDataFromServer();
        return;
      }

      // Check if the current employee data is up to date
      final currentEmployee = employeeProvider.employees!.firstWhere(
        (e) => e.userId == widget.singleEmployee.value.userId,
        orElse: () => null as dynamic,
      );

      if (currentEmployee == null) {
        // Employee not found in current data, refresh
        await _refreshEmployeeDataFromServer();
      } else {
        // Reinitialize the form with the latest data
        setState(() {
          _initializeFormData();
        });
      }
    } catch (e) {
      print('Error ensuring latest data: $e');
    }
  }

  void _initializeFormData() {
    final singleEmployee = widget.singleEmployee;

    // Basic info
    _employeeNameController.text = singleEmployee.value.employeeName;
    _emailIdController.text = singleEmployee.value.email;
    _eidController.text = singleEmployee.value.userId.toString();

    // Gender
    final incomingGender = singleEmployee.value.gender.trim();
    selectedGender =
        genderOptions.contains(incomingGender)
            ? incomingGender
            : genderOptions.first;

    // Employee type - ensure we get the latest value and handle empty strings
    final employeeType = singleEmployee.value.employeeType.trim();
    if (employeeType.isNotEmpty) {
      // Check if the employee type exists in the available options
      final availableTypes =
          singleEmployee.value.allEmployeeTypes
              .map((d) => d.employeeType)
              .toList();

      if (availableTypes.contains(employeeType)) {
        employeeTypeSelected = employeeType;
      } else {
        // If the current type is not in available options, try to find a match
        final matchedType = availableTypes.firstWhere(
          (type) => type.toLowerCase() == employeeType.toLowerCase(),
          orElse: () => availableTypes.isNotEmpty ? availableTypes.first : '',
        );
        employeeTypeSelected = matchedType.isNotEmpty ? matchedType : null;
      }
    } else {
      employeeTypeSelected = null;
    }

    // Job type / designation - ensure we get the latest value and handle empty strings
    final incomingPosition = singleEmployee.value.empDesignation.trim();
    if (incomingPosition.isNotEmpty) {
      // Check if the designation exists in the available options
      final availableDesignations =
          singleEmployee.value.allDesignations
              .map((d) => d.designations)
              .toList();

      if (availableDesignations.contains(incomingPosition)) {
        selectedJobType = incomingPosition;
      } else {
        // If the current designation is not in available options, try to find a match
        final matchedDesignation = availableDesignations.firstWhere(
          (designation) =>
              designation.toLowerCase() == incomingPosition.toLowerCase(),
          orElse:
              () =>
                  availableDesignations.isNotEmpty
                      ? availableDesignations.first
                      : '',
        );
        selectedJobType =
            matchedDesignation.isNotEmpty ? matchedDesignation : null;
      }
    } else {
      selectedJobType = null;
    }

    // Contact & other details
    _contactNumber1.text = singleEmployee.value.homePhone;
    _contactNumber2Controller.text = singleEmployee.value.homePhone;
    _homeContactNumberController.text = singleEmployee.value.homePhone;
    _workPermitNumberController.text = singleEmployee.value.workPermitNumber;
    _emiratesIdController.text = singleEmployee.value.emirateId;
    _joiningDateController.text = singleEmployee.value.joiningDate;
    _contractExpiryController.text = singleEmployee.value.contractExpiryDate;
    _birthDateController.text = singleEmployee.value.dateOfBirth;
    _salaryController.text = singleEmployee.value.salary.toString();
    _incrementController.text = singleEmployee.value.incrementAmount.toString();
    _workingHoursController.text = singleEmployee.value.workingHours.toString();
    _physicalAddressController.text = singleEmployee.value.physicalAddress;
    _noteController.text = singleEmployee.value.extraNote1;

    // Prefill existing bank account data for this user (if any)
    try {
      final List<BankAccount> existingAccounts =
          singleEmployee.value.allBankAccounts;
      if (existingAccounts.isNotEmpty) {
        final String currentUserId = singleEmployee.value.userId.toString();
        BankAccount? matchedUserAccount = existingAccounts.firstWhere(
          (account) => account.userId == currentUserId,
        );

        if (matchedUserAccount != null) {
          _titleNameController.text = matchedUserAccount.titleName;
          _bankAccountController.text = matchedUserAccount.bankAccountNumber;
          _ibanNumberController.text = matchedUserAccount.ibanNumber;
          _contactNumberController.text = matchedUserAccount.contactNumber;
          _emailI2dController.text = matchedUserAccount.emailId;
          _noteController.text = matchedUserAccount.additionalNote;
          _selectedBank = matchedUserAccount.bankName;
        }
      }
    } catch (_) {}
  }

  void _refreshFormData() {
    // Call the same method as initialization to refresh all data
    _initializeFormData();
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
