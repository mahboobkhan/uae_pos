import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../employee/AllEmployeeData.dart';
import '../../../../employee/EmployeeProvider.dart';
import '../../../../employee/employee_models.dart';
import '../../../../providers/signup_provider.dart';
import '../../../../providers/update_ban_account_provider.dart';
import '../../../../providers/employee_payments_provider.dart';
import '../../../dialogs/calender.dart';
import '../../../dialogs/custom_dialoges.dart';
import '../../../dialogs/custom_fields.dart';

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
  final MapEntry<int, Employee> singleEmployee;
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

  final genderOptions = ["Select Gender","Male", "Female"]; // ok
  String? selectedGender; //ok

  String? employeeTypeSelected;
  bool _isSubmitting = false;
  bool _isContractActive = false;
  bool _isEditing = false;
  
  // Salary statistics
  Map<String, dynamic>? _salaryStats;
  bool _isLoadingStats = false;

  @override
  void initState() {
    super.initState();

    _isEditing = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    
    // Fetch salary statistics
    _fetchSalaryStats();
  }

  @override
  Widget build(BuildContext context) {
    final bankList =
        widget.data!.allBanks.map((d) => d.bankName.trim()).toList();
    return SafeArea(
      child: Consumer4<
        UpdateUserBankAccountProvider,
        EmployeeProvider,
        SignupProvider,
        EmployeePaymentsProvider
      >(
        builder: (
          ctx,
          updateUserBankAccountProvider,
          employeeProvider,
          signupProvider,
          employeePaymentsProvider,
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
                                enabled: _isEditing,
                                label: "Employee Type",
                                options: [
                                  'Select Employee Type',
                                  ...widget.singleEmployee.value.allEmployeeTypes
                                      .map((d) => d.employeeType)
                                      .toList(),
                                ],
                                selectedValue: employeeTypeSelected,
                                onChanged: (value) {
                                  if (_isEditing) {
                                    setState(() {
                                      if (value == 'Select Employee Type') {
                                        employeeTypeSelected = null; // reset to default
                                      } else {
                                        employeeTypeSelected = value;
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 180,
                              child: SmallDropdownField(
                                enabled: _isEditing,
                                label: "Select Gender",
                                options: genderOptions,
                                // fixed list
                                selectedValue: selectedGender,
                                onChanged: (value) {
                                  if (_isEditing) {
                                    setState(() {
                                      selectedGender = value=='Select Gender'?null:value;
                                    });
                                  }
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
                          enabled: _isEditing,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdownField(
                              label: "Job Position",
                              enabled: _isEditing,
                              options:
                                  widget.singleEmployee.value.allDesignations
                                      .map((d) => d.designations)
                                      .toList(),
                              selectedValue: selectedJobType,
                              onChanged: (value) {
                                if (_isEditing) {
                                  setState(() {
                                    selectedJobType = value;
                                  });
                                  print("Selected Employee 2: $value");
                                }
                              },
                            ),
                          ],
                        ),
                        CustomTextField(
                          label: "Contact Number",
                          hintText: "+971",
                          controller: _contactNumber1,
                          enabled: _isEditing,
                          keyboardType: TextInputType.number,
                          maxLength: 11,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // only numbers allowed
                          ],
                        ),
                        CustomTextField(
                          label: "Contact No - 2",
                          hintText: "+971",
                          controller: _contactNumber2Controller,
                          enabled: _isEditing,
                          keyboardType: TextInputType.number,
                          maxLength: 11,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // only numbers allowed
                          ],
                        ),
                        CustomTextField(
                          label: "Home Contact No",
                          hintText: "+971",
                          controller: _homeContactNumberController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.number,
                          maxLength: 11,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // only numbers allowed
                          ],
                        ),
                        CustomTextField(
                          label: "Work Permit No",
                          hintText: "+WP-1234",
                          controller: _workPermitNumberController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // only numbers allowed
                          ],
                        ),
                        CustomTextField(
                          label: "Emirates ID",
                          hintText: "1234",
                          controller: _emiratesIdController,
                          enabled: _isEditing,
                          maxLength: 4,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        CustomTextField(
                          label: "Email ID",
                          hintText: "abc@gmail.com",
                          controller: _emailIdController,
                          readOnly: true,
                          enabled: false,
                        ),

                        CustomDateField(
                          label: "Date of Joining",
                          hintText: "dd-MM-yyyy",
                          controller: _joiningDateController,
                          enabled: _isEditing,
                          onTap: () => _pickJoiningDateCupertino(),
                        ),
                        CustomDateField(
                          enabled: _isEditing,
                          label: "Work Contract Expiry",
                          hintText: "dd-MM-yyyy",
                          controller: _contractExpiryController,
                          onTap: _pickContractExpiryDate,
                        ),
                        CustomDateField(
                          label: "Birthday",
                          hintText: "dd-MM-yyyy",
                          controller: _birthDateController,
                          // Use the dedicated controller
                          enabled: _isEditing,
                          onTap: _pickBirthDate, // Use the dedicated function
                        ),
                        CustomTextField(
                          label: 'Salary',
                          hintText: '1000',
                          controller: _salaryController,
                          enabled: _isEditing,
                        ),
                        CustomTextField(
                          label: 'Increment',
                          hintText: '10',
                          controller: _incrementController,
                          enabled: _isEditing,
                        ),
                        CustomTextField(
                          label: 'Working Hours ',
                          hintText: '42',
                          controller: _workingHoursController,
                          enabled: _isEditing,
                        ),
                        /*TextButton(
                          onPressed: () {},
                          child: Text(
                            "Add More",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),*/
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
                            enabled: _isEditing,
                          ),
                        ),
                        SizedBox(
                          width: 450,
                          child: CustomTextField(
                            label: "Note / Extra",
                            controller: _noteController,
                            hintText: 'xxxxx',
                            enabled: _isEditing,
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
                          options: [
                            'Select Bank',
                            ...bankList,
                          ],
                          enabled: _isEditing,
                          selectedValue: _selectedBank,
                          onChanged: (value) {
                            if (_isEditing) {
                              setState(() {
                                if (value == 'Select Bank') {
                                  _selectedBank = null; // reset when default option is selected
                                } else {
                                  _selectedBank = value;
                                }
                              });
                            }
                          },
                        ),
                        CustomTextField(
                          label: "Title Name",
                          hintText: "xxxxxx",
                          controller: _titleNameController,
                          enabled: _isEditing,
                        ),
                        CustomTextField(
                          label: "Bank Account",
                          hintText: "xxxxxxxxxx",
                          controller: _bankAccountController,
                          enabled: _isEditing,
                        ),
                        CustomTextField(
                          label: "IBAN Number",
                          hintText: "xxxxxxxxxxx",
                          controller: _ibanNumberController,
                          enabled: _isEditing,
                        ),
                        CustomTextField(
                          label: "Contact Number",
                          hintText: "+971",
                          controller: _contactNumberController,
                          enabled: _isEditing,
                        ),
                        CustomTextField(
                          label: "Email ID",
                          hintText: "@gmail.com",
                          controller: _emailI2dController,
                          enabled: _isEditing,
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            InfoBox(
                              value: "Remaining Salary",
                              label: _isLoadingStats 
                                  ? "Loading..."
                                  : "${_getRemainingSalary().toStringAsFixed(2)}",
                              color: Colors.blue.shade50,
                            ),
                            InfoBox(
                              value: "Advance Payment",
                              label: _isLoadingStats 
                                  ? "Loading..."
                                  : "${_getAdvancePayment().toStringAsFixed(2)}",
                              color: Colors.blue.shade50,
                            ),
                            InfoBox(
                              value: "Total Salary",
                              label: _isLoadingStats 
                                  ? "Loading..."
                                  : "${_getTotalSalary().toStringAsFixed(2)}",
                              color: Colors.blue.shade50,
                            ),
                            InfoBox(
                              value: "Return Amount",
                              label: _isLoadingStats 
                                  ? "Loading..."
                                  : "${_getReturnAmount().toStringAsFixed(2)}",
                              color: Colors.blue.shade50,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [SizedBox(height: 10)],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        CustomButton(
                          text:
                              _isContractActive
                                  ? "Stop Contract"
                                  : "Start Contract",
                          backgroundColor:
                              _isContractActive ? Colors.orange : Colors.red,
                          onPressed: () async {
                            if (_isContractActive) {
                              await _showVerificationDialogForStop(); // Show PIN verification for stopping contract
                            } else {
                              await _showVerificationDialog(); // Show PIN verification for starting contract
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: _isEditing ? "Editing" : "Edit",
                          backgroundColor:
                              _isEditing ? Colors.blue : Colors.blue,
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                            if (_isEditing) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Edit mode enabled - You can now modify fields",
                                  ),
                                  backgroundColor: Colors.blue,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Edit mode disabled - Fields are now read-only",
                                  ),
                                  backgroundColor: Colors.grey,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: _isSubmitting ? "Updating..." : "Submit",
                          backgroundColor:
                              _isSubmitting
                                  ? Colors.grey
                                  : (_isEditing ? Colors.green : Colors.grey),
                          onPressed: () async {
                            if (_isSubmitting) return;
                            if (!_isEditing) {
                              Navigator.pop(context);
                              return;
                            }
                            final isPinVerified = await _verifyPinForSubmit();
                            if (!isPinVerified) {
                              return;
                            }
                            setState(() {
                              _isSubmitting = true;
                            });

                            try {
                              var bankRequest = UpdateUserBankAccountRequest(
                                userId: widget.singleEmployee.value.userId,
                                bankName: _selectedBank ?? '',
                                branchCode: '',
                                bankAddress: '',
                                titleName: _titleNameController.text.trim(),
                                bankAccountNumber:
                                    _bankAccountController.text.trim(),
                                ibanNumber: _ibanNumberController.text.trim(),
                                contactNumber:
                                    _contactNumberController.text.trim(),
                                emailId: _emailI2dController.text.trim(),
                                additionalNote: '',
                              );
                              await updateUserBankAccountProvider
                                  .updateBankAccount(bankRequest);

                              // Step 4: Update Profile
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

                              //  Refresh data kar raha ha ya
                              await employeeProvider.getFullData();
                              if (mounted) {
                                _initializeFormData();
                              }
                              if (_isSubmitting) return;

                              // Step 2: Verify PIN before any update
                              final isPinVerified = await _verifyPinForSubmit();
                              if (!isPinVerified) {
                                Navigator.pop(context);
                                print(
                                  "PIN verification failed or cancelled - submission aborted",
                                );
                                return;
                              }
                              print(
                                "PIN verification successful - proceeding with submission",
                              );

                              setState(() {
                                _isSubmitting = true;
                              });

                              try {
                                // Step 3: Update Bank Account
                                var bankRequest = UpdateUserBankAccountRequest(
                                  userId: widget.singleEmployee.value.userId,
                                  bankName: _selectedBank ?? '',
                                  branchCode: '',
                                  bankAddress: '',
                                  titleName: _titleNameController.text.trim(),
                                  bankAccountNumber:
                                      _bankAccountController.text.trim(),
                                  ibanNumber: _ibanNumberController.text.trim(),
                                  contactNumber:
                                      _contactNumberController.text.trim(),
                                  emailId: _emailI2dController.text.trim(),
                                  additionalNote: '',
                                );
                                await updateUserBankAccountProvider
                                    .updateBankAccount(bankRequest);
                                print("Bank account updated successfully");

                                // Step 4: Update Profile
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
                                print("Profile updated successfully");

                                // Step 5: Refresh data
                                await employeeProvider.getFullData();
                                if (mounted) {
                                  _initializeFormData();
                                }

                                _showMessage(
                                  context,
                                  "Profile & Bank details updated successfully!",
                                );

                                // Step 6: Close dialog automatically
                                Navigator.pop(context);
                              } catch (e) {
                                print("Error during update: $e");
                                _showMessage(
                                  context,
                                  "Failed to update profile/bank details.",
                                );
                              } finally {
                                setState(() {
                                  _isSubmitting = false;
                                  _isEditing = false;
                                });
                              }
                              Navigator.pop(context);
                            } catch (e) {
                              _showMessage(
                                context,
                                "Failed to update profile/bank details.",
                              );
                            } finally {
                              setState(() {
                                _isSubmitting = false;
                                _isEditing = false;
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

  /// Fetch salary statistics for the employee
  Future<void> _fetchSalaryStats() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingStats = true;
    });

    try {
      final employeePaymentsProvider = Provider.of<EmployeePaymentsProvider>(
        context,
        listen: false,
      );
      
      final employeeRefId = widget.singleEmployee.value.userId.toString();
      final stats = await employeePaymentsProvider.getEmployeeSalaryStats(employeeRefId);
      
      if (mounted) {
        setState(() {
          _salaryStats = stats;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingStats = false;
        });
      }
      print('Error fetching salary stats: $e');
    }
  }

  /// Get remaining salary from stats
  double _getRemainingSalary() {
    if (_salaryStats == null || _salaryStats!['statistics'] == null) return 0.0;
    final stats = _salaryStats!['statistics'];
    return double.tryParse(stats['remaining_salary']?.toString() ?? '0') ?? 0.0;
  }

  /// Get advance payment from stats
  double _getAdvancePayment() {
    if (_salaryStats == null || _salaryStats!['statistics'] == null) return 0.0;
    final stats = _salaryStats!['statistics'];
    return double.tryParse(stats['total_advance_given']?.toString() ?? '0') ?? 0.0;
  }

  /// Get total salary from stats
  double _getTotalSalary() {
    if (_salaryStats == null || _salaryStats!['statistics'] == null) return 0.0;
    final stats = _salaryStats!['statistics'];
    return double.tryParse(stats['total_salary_declared']?.toString() ?? '0') ?? 0.0;
  }

  /// Get return amount from stats
  double _getReturnAmount() {
    if (_salaryStats == null || _salaryStats!['statistics'] == null) return 0.0;
    final stats = _salaryStats!['statistics'];
    return double.tryParse(stats['total_advance_returned']?.toString() ?? '0') ?? 0.0;
  }

  // Method to refresh form when dialog is reopened
  void _refreshFormOnReopen() {
    if (mounted) {
      setState(() {
        _ensureLatestData();
        _fetchSalaryStats(); // Also refresh salary statistics
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
          _fetchSalaryStats(); // Also refresh salary statistics
        });
      }
    } catch (e) {}
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
          _fetchSalaryStats(); // Also refresh salary statistics
        });
      }
    } catch (e) {}
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

    // Load contract state from shared preferences
    _loadContractState();

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
  /*
  bool _hasFormChanges() {
    final originalEmployee = widget.singleEmployee.value;

    // Check if any employee profile field has changed from the original values
    final hasProfileChanges =
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



  }
*/

  // Helper method to check if any bank account fields have changed
  /*
  bool _hasBankAccountChanges() {
    // Get the original bank account data for comparison
    final originalEmployee = widget.singleEmployee.value;
    BankAccount? originalBankAccount;

    try {
      final List<BankAccount> existingAccounts =
          originalEmployee.allBankAccounts;
      if (existingAccounts.isNotEmpty) {
        final String currentUserId = originalEmployee.userId.toString();
        originalBankAccount = existingAccounts.firstWhere(
          (account) => account.userId == currentUserId,
        );
      }
    } catch (_) {}

    // Check if any bank account field has been modified from original values
    final hasChanges =
        _titleNameController.text.trim() !=
            (originalBankAccount?.titleName ?? '') ||
        _bankAccountController.text.trim() !=
            (originalBankAccount?.bankAccountNumber ?? '') ||
        _ibanNumberController.text.trim() !=
            (originalBankAccount?.ibanNumber ?? '') ||
        _contactNumberController.text.trim() !=
            (originalBankAccount?.contactNumber ?? '') ||
        _emailI2dController.text.trim() !=
            (originalBankAccount?.emailId ?? '') ||
        _selectedBank != (originalBankAccount?.bankName?.trim() ?? '');

    // Debug: Print bank account change detection
    print("Bank Account Change Detection:");
    print(
      "  Original Bank Account: ${originalBankAccount != null ? 'Found' : 'Not found'}",
    );
    if (originalBankAccount != null) {
      print("  Original Title Name: '${originalBankAccount.titleName}'");
      print(
        "  Original Account Number: '${originalBankAccount.bankAccountNumber}'",
      );
      print("  Original IBAN: '${originalBankAccount.ibanNumber}'");
      print("  Original Contact: '${originalBankAccount.contactNumber}'");
      print("  Original Email: '${originalBankAccount.emailId}'");
      print("  Original Bank: '${originalBankAccount.bankName}'");
    }
    print("  Current Title Name: '${_titleNameController.text.trim()}'");
    print("  Current Account Number: '${_bankAccountController.text.trim()}'");
    print("  Current IBAN: '${_ibanNumberController.text.trim()}'");
    print("  Current Contact: '${_contactNumberController.text.trim()}'");
    print("  Current Email: '${_emailI2dController.text.trim()}'");
    print("  Current Selected Bank: '$_selectedBank'");
    print("  Has Changes: $hasChanges");

    return hasChanges;
  }
*/

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

  // Add verification dialog method
  Future<void> _showVerificationDialog() async {
    final TextEditingController verificationController =
        TextEditingController();

    // 🔹 Load the saved PIN from SharedPreferences (same key as used in _verifyPinForSubmit)
    final prefs = await SharedPreferences.getInstance();
    final savedVerificationCode =
        prefs.getString('pin') ?? '1234'; // Use 'pin' key with fallback

    String? verificationCode;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Contract Verification",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Please enter your 4-digit PIN to start the contract",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: verificationController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, letterSpacing: 8),
                  decoration: const InputDecoration(
                    labelText: 'PIN',
                    hintText: '',
                    border: OutlineInputBorder(),
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    // Remove auto-verification to prevent accidental contract starting
                    // User must click the Verify button to proceed
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                final enteredCode = verificationController.text.trim();
                if (enteredCode == savedVerificationCode) {
                  Navigator.of(context).pop();
                  _startContract();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid PIN. Please try again."),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  verificationController.clear();
                }
              },
              child: const Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Add verification dialog method for stopping contract
  Future<void> _showVerificationDialogForStop() async {
    final TextEditingController verificationController =
        TextEditingController();

    // 🔹 Load the saved PIN from SharedPreferences (same key as used in _verifyPinForSubmit)
    final prefs = await SharedPreferences.getInstance();
    final savedVerificationCode =
        prefs.getString('pin') ?? '1234'; // Use 'pin' key with fallback

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Stop Contract Verification",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Please enter your 4-digit PIN to stop the contract",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: verificationController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, letterSpacing: 8),
                  decoration: const InputDecoration(
                    labelText: 'PIN',
                    hintText: '',
                    border: OutlineInputBorder(),
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    // Remove auto-verification to prevent accidental contract stopping
                    // User must click the Verify button to proceed
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                final enteredCode = verificationController.text.trim();
                if (enteredCode == savedVerificationCode) {
                  Navigator.of(context).pop();
                  _stopContract();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid PIN. Please try again."),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  verificationController.clear();
                }
              },
              child: const Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // PIN verification method for Submit button
  Future<bool> _verifyPinForSubmit() async {
    final TextEditingController verificationController =
        TextEditingController();
    String? verificationCode;

    try {
      // Get verification code from shared preferences (from signup provider login)
      final prefs = await SharedPreferences.getInstance();
      verificationCode = prefs.getString('pin') ?? '1234'; // Default fallback
    } catch (e) {
      verificationCode = '1234'; // Fallback code
    }

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                "Submit Verification",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Please enter your PIN to confirm form submission",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: verificationController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, letterSpacing: 8),
                      decoration: const InputDecoration(
                        labelText: 'Verification Code',
                        hintText: '',
                        border: OutlineInputBorder(),
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 4) {
                          // Auto-verify when 4 digits are entered
                          if (value == verificationCode) {
                            Navigator.of(
                              context,
                            ).pop(true); // Return true for success
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Invalid verification code. Please try again.",
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            verificationController.clear();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  // Return false for cancel
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    final enteredCode = verificationController.text.trim();
                    if (enteredCode == verificationCode) {
                      Navigator.of(
                        context,
                      ).pop(true); // Return true for success
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Invalid verification code. Please try again.",
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      verificationController.clear();
                    }
                  },
                  child: const Text(
                    'Verify & Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }

  Future<void> _startContract() async {
    setState(() {
      _isContractActive = true;
    });

    // Save contract state to shared preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
        'is_contract_active_${widget.singleEmployee.value.userId}',
        true,
      );
    } catch (e) {}

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Contract started successfully!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _stopContract() async {
    setState(() {
      _isContractActive = false;
    });

    // Save contract state to shared preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
        'is_contract_active_${widget.singleEmployee.value.userId}',
        false,
      );
    } catch (e) {}

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Contract stopped successfully!"),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Method to load contract state from shared preferences
  Future<void> _loadContractState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isContractActive =
          prefs.getBool(
            'is_contract_active_${widget.singleEmployee.value.userId}',
          ) ??
          false;
      setState(() {
        _isContractActive = isContractActive;
      });
    } catch (e) {}
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
