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
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Add listener to refresh form when employee data changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /*   final employeeProvider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );
      employeeProvider.addListener(_onEmployeeDataChanged);
     */

      // Ensure we have the latest data when dialog opens
      _ensureLatestData();
      final bankList =
          widget.data!.allBanks.map((d) => d.bankName.trim()).toList();

      if (!bankList.contains(_selectedBank)) {
        _selectedBank = null; // or set to a default
      }
    });
    // Initialize form with current employee data
    _initializeFormData();
  }

  @override
  Widget build(BuildContext context) {
    final bankList =
        widget.data!.allBanks.map((d) => d.bankName.trim()).toList();
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
                          options: bankList,
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
                          text: _isSubmitting ? "Updating..." : "Submit",
                          backgroundColor:
                              _isSubmitting ? Colors.grey : Colors.green,
                          onPressed:
                              _isSubmitting
                                  ? () {
                                    Navigator.pop(context);
                                  }
                                  : () async {
                                    setState(() {
                                      _isSubmitting = true;
                                    });

                                    print("=== SUBMIT BUTTON CLICKED ===");
                                    print("Form submission started...");

                                    // Check if any fields have actually changed
                                    if (!_hasFormChanges()) {
                                      print(
                                        "No form changes detected - closing dialog",
                                      );
                                      // No changes, show message and close the dialog
                                      setState(() {
                                        _isSubmitting = false;
                                      });
                                      _showMessage(
                                        context,
                                        "No changes detected. Dialog will close.",
                                      );
                                      Navigator.pop(context);
                                      return;
                                    }

                                    print(
                                      "Form changes detected - proceeding with submission",
                                    );

                                    final String currentUserId =
                                        widget.singleEmployee.value.userId;
                                    final String enteredAccountNumber =
                                        _bankAccountController.text.trim();

                                    // First: update employee profile fields
                                    final profilePayload = <String, dynamic>{
                                      'user_id':
                                          widget.singleEmployee.value.userId,
                                      'employee_name':
                                          _employeeNameController.text.trim(),
                                      'email': _emailIdController.text.trim(),
                                      'home_phone': _contactNumber1.text.trim(),
                                      'alternate_phone':
                                          _contactNumber2Controller.text.trim(),
                                      'personal_phone':
                                          _homeContactNumberController.text
                                              .trim(),
                                      'work_permit_number':
                                          _workPermitNumberController.text
                                              .trim(),
                                      'emirate_id':
                                          _emiratesIdController.text.trim(),
                                      'joining_date': _formatDateForAPI(
                                        _joiningDateController.text.trim(),
                                      ),
                                      'contract_expiry_date': _formatDateForAPI(
                                        _contractExpiryController.text.trim(),
                                      ),
                                      'date_of_birth': _formatDateForAPI(
                                        _birthDateController.text.trim(),
                                      ),
                                      'physical_address':
                                          _physicalAddressController.text
                                              .trim(),
                                      'extra_note_1':
                                          _noteController.text.trim(),
                                      'gender': selectedGender ?? '',
                                      'emp_designation': selectedJobType ?? '',
                                      'employee_type':
                                          employeeTypeSelected ?? '',
                                      'salary': _salaryController.text.trim(),
                                      'increment_amount':
                                          _incrementController.text.trim(),
                                      'working_hours':
                                          _workingHoursController.text.trim(),
                                    };
                                    print(
                                      "salary 444: '${_salaryController.text.trim()}'",
                                    );

                                    print("Payload: $profilePayload");
                                    print(
                                      "Note being sent: '${_noteController.text.trim()}'",
                                    );
                                    final profileRes = await signupProvider
                                        .updateEmployeeProfile(profilePayload);

                                    // Debug: Print the full response
                                    print(
                                      "Profile Update Response: $profileRes",
                                    );

                                    if (profileRes['success'] != true) {
                                      _showMessage(
                                        context,
                                        profileRes['message'] ??
                                            'Profile update failed',
                                      );
                                      return;
                                    }
                                    // Show success message for profile update
                                    _showMessage(
                                      context,
                                      "Profile updated successfully!",
                                    );

                                    print(
                                      "=== CHECKING BANK ACCOUNT FIELDS ===",
                                    );
                                    print("Selected Bank: '$_selectedBank'");
                                    print(
                                      "Title Name: '${_titleNameController.text.trim()}'",
                                    );
                                    print(
                                      "Account Number: '${_bankAccountController.text.trim()}'",
                                    );
                                    print(
                                      "IBAN: '${_ibanNumberController.text.trim()}'",
                                    );
                                    print(
                                      "Contact Number: '${_contactNumberController.text.trim()}'",
                                    );
                                    print(
                                      "Email ID: '${_emailI2dController.text.trim()}'",
                                    );

                                    // Now create the bank account if there are bank details
                                    final hasBankChanges =
                                        _hasBankAccountChanges();
                                    print(
                                      "_hasBankAccountChanges() returned: $hasBankChanges",
                                    );

                                    if (hasBankChanges) {
                                      print(
                                        "Bank account changes detected, proceeding with creation...",
                                      );
                                      try {
                                        // Get the existing bank account for this user
                                        final existingAccounts =
                                            widget
                                                .singleEmployee
                                                .value
                                                .allBankAccounts ??
                                            [];

                                        if (existingAccounts.isNotEmpty) {
                                          final String currentUserId =
                                              widget.singleEmployee.value.userId
                                                  .toString();

                                          // Check if user has an existing bank account
                                          final existingBankAccount =
                                              existingAccounts.firstWhere(
                                                (account) =>
                                                    account.userId ==
                                                    currentUserId,
                                                orElse: () => null as dynamic,
                                              );

                                          if (existingBankAccount != null) {
                                            print(
                                              "Existing bank account found, updating...",
                                            );
                                            // Update existing bank account
                                            await updateUserBankAccountProvider
                                                .updateBankAccount(
                                                  UpdateUserBankAccountRequest(
                                                    bankAccountId:
                                                        existingBankAccount.id,
                                                    // Use existing ID
                                                    userId: currentUserId,
                                                    bankName:
                                                        _selectedBank ??
                                                        existingBankAccount
                                                            .bankName ??
                                                        "N/A",
                                                    branchCode:
                                                        existingBankAccount
                                                            .branchCode ??
                                                        "N/A",
                                                    bankAddress:
                                                        existingBankAccount
                                                            .bankAddress ??
                                                        "N/A",
                                                    titleName:
                                                        _titleNameController
                                                            .text
                                                            .trim(),
                                                    bankAccountNumber:
                                                        _bankAccountController
                                                            .text
                                                            .trim(),
                                                    ibanNumber:
                                                        _ibanNumberController
                                                            .text
                                                            .trim(),
                                                    contactNumber:
                                                        _contactNumberController
                                                            .text
                                                            .trim(),
                                                    emailId:
                                                        _emailI2dController.text
                                                            .trim(),
                                                    additionalNote:
                                                        _noteController.text
                                                            .trim(),
                                                  ),
                                                );
                                          } else {
                                            print(
                                              "No existing bank account found, creating new one...",
                                            );
                                            // Create new bank account
                                            await createUserBankAccountProvider
                                                .createBankAccount(
                                                  CreateUserBankAccountRequest(
                                                    userId: currentUserId,
                                                    bankName:
                                                        _selectedBank ?? "N/A",
                                                    branchCode: "N/A",
                                                    bankAddress: "N/A",
                                                    titleName:
                                                        _titleNameController
                                                            .text
                                                            .trim(),
                                                    bankAccountNumber:
                                                        _bankAccountController
                                                            .text
                                                            .trim(),
                                                    ibanNumber:
                                                        _ibanNumberController
                                                            .text
                                                            .trim(),
                                                    contactNumber:
                                                        _contactNumberController
                                                            .text
                                                            .trim(),
                                                    emailId:
                                                        _emailI2dController.text
                                                            .trim(),
                                                    additionalNote:
                                                        _noteController.text
                                                            .trim(),
                                                    createdBy: currentUserId,
                                                  ),
                                                );
                                          }

                                          // Wait a bit for the state to update
                                          await Future.delayed(
                                            Duration(milliseconds: 100),
                                          );

                                          // Check the appropriate provider state based on what we did
                                          if (existingBankAccount != null) {
                                            // We updated an existing account
                                            print(
                                              "Bank account update completed. State: ${updateUserBankAccountProvider.state}",
                                            );
                                            print(
                                              "Error message: ${updateUserBankAccountProvider.errorMessage}",
                                            );

                                            if (updateUserBankAccountProvider
                                                    .state ==
                                                RequestState.success) {
                                              _showMessage(
                                                context,
                                                "Profile and bank account updated successfully!",
                                              );
                                            } else {
                                              _showMessage(
                                                context,
                                                "Profile updated but bank account update failed: ${updateUserBankAccountProvider.errorMessage ?? 'Unknown error'}",
                                              );
                                            }
                                          } else {
                                            // We created a new account
                                            print(
                                              "Bank account creation completed. State: ${createUserBankAccountProvider.state}",
                                            );
                                            print(
                                              "Error message: ${createUserBankAccountProvider.errorMessage}",
                                            );

                                            if (createUserBankAccountProvider
                                                    .state ==
                                                RequestState.success) {
                                              _showMessage(
                                                context,
                                                "Profile and bank account created successfully!",
                                              );
                                            } else {
                                              _showMessage(
                                                context,
                                                "Profile updated but bank account creation failed: ${createUserBankAccountProvider.errorMessage ?? 'Unknown error'}",
                                              );
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        print("Bank account update error: $e");
                                        _showMessage(
                                          context,
                                          "Profile updated but bank account update failed: $e",
                                        );
                                      }
                                    }

                                    // Close dialog after all updates
                                    Navigator.pop(context);

                                    // Refresh employee data
                                    await employeeProvider.getFullData();
                                    // Repopulate profile controllers from server
                                    final updatedEmp = employeeProvider
                                        .employees
                                        ?.firstWhere(
                                          (e) => e.userId == currentUserId,
                                          orElse: () => null as dynamic,
                                        );
                                    if (updatedEmp != null) {
                                      // Debug: Print the received employee data
                                      print("Updated Employee Data:");
                                      print("  ID: ${updatedEmp.userId}");
                                      print(
                                        "  Name: ${updatedEmp.employeeName}",
                                      );
                                      print(
                                        "  Note: '${updatedEmp.extraNote1}'",
                                      );

                                      setState(() {
                                        _employeeNameController.text =
                                            updatedEmp.employeeName;
                                        _emailIdController.text =
                                            updatedEmp.email;
                                        _contactNumber1.text =
                                            updatedEmp.homePhone;
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
                                        _noteController.text =
                                            updatedEmp.extraNote1;

                                        print(
                                          "Received Note (extraNote1): '${updatedEmp.extraNote1}'",
                                        );
                                        print(
                                          "Note Controller Value after update: '${_noteController.text}'",
                                        );
                                        selectedGender = updatedEmp.gender;
                                      });
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
        },
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /*
  @override
  void dispose() {
    final employeeProvider = Provider.of<EmployeeProvider>(
      context,
      listen: false,
    );
    super.dispose();
  }

  void _onEmployeeDataChanged() {
    if (mounted) {
      setState(() {
        _refreshFormData();
      });
    }
  }
*/

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
    _contactNumber2Controller.text = singleEmployee.value.alternatePhone;
    _homeContactNumberController.text = singleEmployee.value.personalPhone;
    _workPermitNumberController.text = singleEmployee.value.workPermitNumber;
    _emiratesIdController.text = singleEmployee.value.emirateId;
    // Format dates properly
    _joiningDateController.text = _formatDateForDisplay(
      singleEmployee.value.joiningDate,
    );
    _contractExpiryController.text = _formatDateForDisplay(
      singleEmployee.value.contractExpiryDate,
    );
    _birthDateController.text = _formatDateForDisplay(
      singleEmployee.value.dateOfBirth,
    );
    _salaryController.text = singleEmployee.value.salary.toString();
    _incrementController.text = singleEmployee.value.incrementAmount.toString();
    _workingHoursController.text = singleEmployee.value.workingHours.toString();
    _physicalAddressController.text = singleEmployee.value.physicalAddress;
    _noteController.text = singleEmployee.value.extraNote1 ?? '';

    // Debug: Print the note value to console
    print("Employee Note (extraNote1): '${singleEmployee.value.extraNote1}'");
    print("Note Controller Value: '${_noteController.text}'");
    print("Employee ID: ${singleEmployee.value.userId}");
    print("Employee Name: ${singleEmployee.value.employeeName}");

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
          // Note: Bank account notes are not displayed in this employee profile form
          // The note field is specifically for employee profile notes
          _selectedBank = matchedUserAccount.bankName?.trim();
        }
      }
    } catch (_) {}
  }

  // Helper method to format dates for display
  String _formatDateForDisplay(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }

    try {
      // Try to parse the date and format it
      final parsedDate = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      // If parsing fails, return the original string
      return dateString;
    }
  }

  // Helper method to format dates for API submission
  String _formatDateForAPI(String dateString) {
    if (dateString.isEmpty) {
      return '';
    }

    try {
      // Parse the dd-MM-yyyy format and convert to yyyy-MM-dd for API
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dateString);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      // If parsing fails, return the original string
      return dateString;
    }
  }

  // Helper method to check if any form fields have changed
  bool _hasFormChanges() {
    final originalEmployee = widget.singleEmployee.value;

    // Check if any field has changed from the original values
    final hasChanges =
        _employeeNameController.text.trim() != originalEmployee.employeeName ||
        _emailIdController.text.trim() != originalEmployee.email ||
        _contactNumber1.text.trim() != (originalEmployee.homePhone ?? '') ||
        _contactNumber2Controller.text.trim() !=
            (originalEmployee.alternatePhone ?? '') ||
        _homeContactNumberController.text.trim() !=
            (originalEmployee.personalPhone ?? '') ||
        _workPermitNumberController.text.trim() !=
            (originalEmployee.workPermitNumber ?? '') ||
        _emiratesIdController.text.trim() !=
            (originalEmployee.emirateId ?? '') ||
        _joiningDateController.text.trim() !=
            _formatDateForDisplay(originalEmployee.joiningDate) ||
        _contractExpiryController.text.trim() !=
            _formatDateForDisplay(originalEmployee.contractExpiryDate) ||
        _birthDateController.text.trim() !=
            _formatDateForDisplay(originalEmployee.dateOfBirth) ||
        _physicalAddressController.text.trim() !=
            (originalEmployee.physicalAddress ?? '') ||
        _noteController.text.trim() != (originalEmployee.extraNote1 ?? '') ||
        selectedGender != originalEmployee.gender ||
        selectedJobType != originalEmployee.empDesignation ||
        employeeTypeSelected != originalEmployee.employeeType ||
        _salaryController.text.trim() !=
            (originalEmployee.salary?.toString() ?? '') ||
        _incrementController.text.trim() !=
            (originalEmployee.incrementAmount?.toString() ?? '') ||
        _workingHoursController.text.trim() !=
            (originalEmployee.workingHours?.toString() ?? '');

    // Debug: Print what changes were detected
    if (!hasChanges) {
      print("No form changes detected - all fields match original values");
    } else {
      print("Form changes detected - some fields have been modified");
    }

    return hasChanges;
  }

  // Helper method to check if any bank account fields have changed
  bool _hasBankAccountChanges() {
    // Check if any bank account field has been modified
    final hasChanges =
        _titleNameController.text.trim().isNotEmpty ||
        _bankAccountController.text.trim().isNotEmpty ||
        _ibanNumberController.text.trim().isNotEmpty ||
        _contactNumberController.text.trim().isNotEmpty ||
        _emailI2dController.text.trim().isNotEmpty ||
        _selectedBank != null;

    // Debug: Print bank account change detection
    print("Bank Account Change Detection:");
    print(
      "  Title Name: '${_titleNameController.text.trim()}' (${_titleNameController.text.trim().isNotEmpty})",
    );
    print(
      "  Account Number: '${_bankAccountController.text.trim()}' (${_bankAccountController.text.trim().isNotEmpty})",
    );
    print(
      "  IBAN: '${_ibanNumberController.text.trim()}' (${_ibanNumberController.text.trim().isNotEmpty})",
    );
    print(
      "  Contact: '${_contactNumberController.text.trim()}' (${_contactNumberController.text.trim().isNotEmpty})",
    );
    print(
      "  Email: '${_emailI2dController.text.trim()}' (${_emailI2dController.text.trim().isNotEmpty})",
    );
    print("  Selected Bank: '$_selectedBank' (${_selectedBank != null})");
    print("  Has Changes: $hasChanges");

    return hasChanges;
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
