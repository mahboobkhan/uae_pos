import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/client_organization_employee_provider.dart';
import 'custom_dialoges.dart';
import 'custom_fields.dart';

Future<void> showAddRelationsDialog(
  BuildContext context, {
  required String clientRefId,
  Map<String, dynamic>? relationData,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: AddRelationsDialog(clientRefId: clientRefId, relationData: relationData),
        ),
  );
}

class AddRelationsDialog extends StatefulWidget {
  final String clientRefId;
  final Map<String, dynamic>? relationData;

  const AddRelationsDialog({super.key, required this.clientRefId, this.relationData});

  @override
  State<AddRelationsDialog> createState() => _AddRelationsDialogState();
}

class _AddRelationsDialogState extends State<AddRelationsDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emirateIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String? _selectedType;
  String? _selectedStatus;
  final List<String> _relationTypes = ['Family Member', 'Business Partner', 'Other'];
  final List<String> _statusOptions = ['Active', 'Inactive'];
  
  @override
  void initState() {
    super.initState();
    // Set default status to null to show hint
    _selectedStatus = null;
    
    // Prefill data if editing
    if (widget.relationData != null) {
      _nameController.text = (widget.relationData!['name'] ?? '').toString();
      _emirateIdController.text = (widget.relationData!['emirate_id'] ?? '').toString();
      _emailController.text = (widget.relationData!['email'] ?? '').toString();
      _contactController.text = (widget.relationData!['contact_no'] ?? '').toString();
      _selectedType = (widget.relationData!['type'] ?? '').toString();
      _selectedStatus = widget.relationData!['status']?.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emirateIdController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.relationData != null;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        isEdit ? 'Edit Relation' : 'Add Relation',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const SizedBox(width: 15),
                      CustomDropdownField(
                        label: "Select Status",
                        options: _statusOptions,
                        selectedValue: _selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                        width: 150,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Form Fields
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomDropdownField(
                    label: "Relation Type",
                    options: _relationTypes,
                    selectedValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                  ),
                  CustomTextField(label: "Name", controller: _nameController, hintText: "Enter relation name"),
                  CustomTextField(
                    label: "Emirates ID",
                    controller: _emirateIdController,
                    hintText: "784-XXXX-XXXXXXX-X",
                  ),
                  CustomTextField(label: "Email", controller: _emailController, hintText: "john@example.com"),
                  CustomTextField(label: "Contact No", controller: _contactController, hintText: "+971501234567"),
                ],
              ),

              const SizedBox(height: 20),

              // Error/Success Messages
              Consumer<ClientOrganizationEmployeeProvider>(
                builder: (context, provider, child) {
                  if (provider.errorMessage != null) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(child: Text(provider.errorMessage!, style: TextStyle(color: Colors.red))),
                          IconButton(
                            onPressed: () => provider.clearMessages(),
                            icon: Icon(Icons.close, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.successMessage != null) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(child: Text(provider.successMessage!, style: TextStyle(color: Colors.green))),
                          IconButton(
                            onPressed: () => provider.clearMessages(),
                            icon: Icon(Icons.close, color: Colors.green),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              // Action Buttons
              Row(
                children: [
                  CustomButton(
                    text: "Cancel",
                    backgroundColor: Colors.grey,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 10),
                  Consumer<ClientOrganizationEmployeeProvider>(
                    builder: (context, provider, child) {
                      return CustomButton(
                        text: isEdit ? "Update" : "Add Relation",
                        backgroundColor: Colors.green,
                        onPressed:
                            provider.isLoading
                                ? () async {}
                                : () async {
                                  if (_validateForm()) {
                                    if (isEdit) {
                                      await provider.updateEmployee(
                                        employeeRefId: widget.relationData!['employee_ref_id'],
                                        type: _selectedType,
                                        name:
                                            _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
                                        emirateId:
                                            _emirateIdController.text.trim().isNotEmpty
                                                ? _emirateIdController.text.trim()
                                                : null,
                                        email:
                                            _emailController.text.trim().isNotEmpty
                                                ? _emailController.text.trim()
                                                : null,
                                        contactNo:
                                            _contactController.text.trim().isNotEmpty
                                                ? _contactController.text.trim()
                                                : null,
                                      );
                                    } else {
                                      await provider.addEmployee(
                                        clientRefId: widget.clientRefId,
                                        type: _selectedType!,
                                        name: _nameController.text.trim(),
                                        emirateId: _emirateIdController.text.trim(),
                                        workPermitNo: '', // Empty work permit for relations
                                        email: _emailController.text.trim(),
                                        contactNo: _contactController.text.trim(),
                                      );
                                    }

                                    if (provider.errorMessage == null) {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                      );
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

  bool _validateForm() {
    if (_selectedType == null || _selectedType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select relation type')));
      return false;
    }

    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select status')));
      return false;
    }

    if (_emirateIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Emirates ID')));
      return false;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter email')));
      return false;
    }

    if (_contactController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter contact number')));
      return false;
    }

    return true;
  }
}
