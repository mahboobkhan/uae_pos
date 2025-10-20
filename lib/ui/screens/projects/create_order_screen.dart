import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/client_profile_provider.dart';
import '../../../providers/project_stage_provider.dart';
import '../../../providers/projects_provider.dart';
import '../../../providers/service_category_provider.dart';
import '../../dialogs/calender.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';
import '../../../utils/pin_verification_util.dart';

class DropdownItem {
  final String id;
  final String label;

  DropdownItem(this.id, this.label);

  @override
  String toString() => label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownItem && runtimeType == other.runtimeType && id == other.id && label == other.label;

  @override
  int get hashCode => id.hashCode ^ label.hashCode;
}

class CreateOrderScreen extends StatefulWidget {
  final Map<String, dynamic>? projectData;

  const CreateOrderScreen({super.key, this.projectData});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  String? selectedService;
  final _beneficiaryController = TextEditingController();
  final _recordPaymentController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();

  final _fundsController = TextEditingController(text: "");
  String? selectedOrderType;
  String? searchClient;
  String? selectedServiceProject;
  String? selectedEmployee;
  String? selectedServiceProvider;
  Map<String, dynamic>? _selectedClient;
  List<DropdownItem> orderTypes = [DropdownItem("001", "Services Base"), DropdownItem("002", "Project Base")];

  DateTime selectedDateTime = DateTime.now();

  // Edit mode state
  bool _isEditMode = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;
  String _projectStatus = 'draft';

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _loadProjectStages();
    _loadProvidersData();
  }

  void _loadProjectStages() {
    if (widget.projectData != null && widget.projectData!['project_ref_id'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final projectStageProvider = context.read<ProjectStageProvider>();
          projectStageProvider.getStagesByProject(projectRefId: widget.projectData!['project_ref_id']).then((_) {
            // Refresh calculations when stages are loaded
            if (mounted) {
              setState(() {
                // This will trigger a rebuild and recalculate all values
              });
            }
          });
        }
      });
    }
  }

  void _loadProvidersData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final clientProvider = context.read<ClientProfileProvider>();
        final serviceProvider = context.read<ServiceCategoryProvider>();

        // Load clients if not already loaded
        if (clientProvider.clients.isEmpty && !clientProvider.isLoading) {
          clientProvider.getAllClients();
        }

        // Load service categories if not already loaded
        if (serviceProvider.serviceCategories.isEmpty && !serviceProvider.isLoading) {
          serviceProvider.getServiceCategories();
        }
      }
    });
  }

  /// Calculate remaining payment
  String calculateRemaining(String? quotation, String? paidPayment) {
    final double q = double.tryParse(quotation ?? '0') ?? 0;
    final double p = double.tryParse(paidPayment ?? '0') ?? 0;
    final double remaining = q - p;

    return remaining.toStringAsFixed(2); // Always 2 decimal places
  }

  /// Calculate total steps cost from project stages
  double calculateTotalStepsCost() {
    final projectStageProvider = context.read<ProjectStageProvider>();
    double total = 0.0;

    for (final stage in projectStageProvider.projectStages) {
      final stepCost = double.tryParse(stage['step_cost']?.toString() ?? '0') ?? 0.0;
      total += stepCost;
    }

    return total;
  }

  /// Calculate total additional profit from project stages
  double calculateTotalAdditionalProfit() {
    final projectStageProvider = context.read<ProjectStageProvider>();
    double total = 0.0;

    for (final stage in projectStageProvider.projectStages) {
      final additionalProfit = double.tryParse(stage['additional_profit']?.toString() ?? '0') ?? 0.0;
      total += additionalProfit;
    }

    return total;
  }

  /// Calculate total steps received amount from project stages
  double calculateTotalStepsReceivedAmount() {
    final projectStageProvider = context.read<ProjectStageProvider>();
    double total = 0.0;

    for (final stage in projectStageProvider.projectStages) {
      final receivedAmount = double.tryParse(stage['received_amount']?.toString() ?? '0') ?? 0.0;
      total += receivedAmount;
    }

    return total;
  }

  /// Calculate pending payment using the larger value between quotation and total steps cost
  String calculatePendingPayment(String? quotation, String? paidPayment) {
    final double quotationAmount = double.tryParse(quotation ?? '0') ?? 0;
    final double totalStepsCost = calculateTotalStepsCost();
    final double paidAmount = double.tryParse(paidPayment ?? '0') ?? 0;

    // Use the larger value between quotation and total steps cost
    final double totalAmount = quotationAmount > totalStepsCost ? quotationAmount : totalStepsCost;
    final double remaining = totalAmount - paidAmount;

    return remaining.toStringAsFixed(2);
  }

  void _initializeFormData() {
    if (widget.projectData != null) {
      final project = widget.projectData!;

      // Pre-fill form fields with project data
      _beneficiaryController.text = project['client_name'] ?? '';
      _fundsController.text = project['quotation'] ?? '';
      // Use the new pending payment calculation that considers both quotation and total steps cost
      _recordPaymentController.text = calculatePendingPayment(project['quotation'], project['paid_payment']);

      // Set order type
      selectedOrderType = project['order_type'] ?? '';

      // Set and track project status
      _projectStatus = (project['status'] ?? 'draft').toString();

      // Set service project (only if not empty)
      final serviceName = project['service_category_id']?['service_name']?.toString();
      selectedServiceProject = (serviceName != null && serviceName.isNotEmpty) ? serviceName : null;

      // Set service provider (only if not empty)
      final serviceProviderName = project['service_category_id']?['service_provider_name']?.toString();
      selectedServiceProvider =
          (serviceProviderName != null && serviceProviderName.isNotEmpty) ? serviceProviderName : null;

      // Set employee
      selectedEmployee = project['user_id']?['name'] ?? '';

      // Set client (only if not empty)
      if (project['client_id'] != null) {
        _selectedClient = project['client_id'];
        final clientName = project['client_id']?['name']?.toString();
        searchClient = (clientName != null && clientName.isNotEmpty) ? clientName : null;
      }

      // Set date if available
      if (project['created_at'] != null) {
        try {
          selectedDateTime = DateTime.parse(project['created_at']);
        } catch (e) {
          selectedDateTime = DateTime.now();
        }
      }
    }
  }

  bool get _isProjectLocked => false; // Remove project locking to allow editing at any stage

  Future<void> _updateProjectStatus(String newStatus) async {
    if (widget.projectData == null) return;
    try {
      final provider = context.read<ProjectsProvider>();
      await provider.updateProject(projectRefId: widget.projectData!['project_ref_id'], status: newStatus);
      if (provider.errorMessage == null) {
        setState(() {
          _projectStatus = newStatus;
          _successMessage = provider.successMessage ?? 'Status updated';
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = provider.errorMessage;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating status: $e';
      });
    }
  }

  // Get service names for dropdown
  List<String> _getServiceNames() {
    final provider = context.read<ServiceCategoryProvider>();
    return provider.serviceCategories.map((service) => service['service_name'].toString() ?? '').toList();
  }

  // Get service provider names for dropdown
  List<String> _getServiceProviderNames() {
    final provider = context.read<ServiceCategoryProvider>();
    return provider.serviceCategories.map((service) => service['service_provider_name'].toString() ?? '').toList();
  }

  // Get quotation price for selected service
  String? _getQuotationForService(String? serviceName) {
    if (serviceName == null) return null;
    final provider = context.read<ServiceCategoryProvider>();
    final service = provider.serviceCategories.firstWhere(
      (service) => service['service_name'] == serviceName,
      orElse: () => {},
    );
    return service['quotation']?.toString();
  }

  // Get service provider for selected service
  String? _getServiceProviderForService(String? serviceName) {
    if (serviceName == null) return null;
    final provider = context.read<ServiceCategoryProvider>();
    final service = provider.serviceCategories.firstWhere(
      (service) => service['service_name'] == serviceName,
      orElse: () => {},
    );
    return service['service_provider_name']?.toString();
  }

  // Toggle edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      _errorMessage = null;
      _successMessage = null;
    });
  }

  // Show PIN verification dialog

  Future<bool> _showPinVerificationDialog() async {
    final TextEditingController verificationController = TextEditingController();
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: const Text(
                "Submit Verification",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (value) {
                        /*if (value.length == 4) {
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
                    }*/
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  // Return false for cancel
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () {
                    final enteredCode = verificationController.text.trim();
                    if (enteredCode == verificationCode) {
                      Navigator.of(context).pop(true); // Return true for success
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid verification code. Please try again."),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      verificationController.clear();
                    }
                  },
                  child: const Text('Verify & Submit', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }

  // Save project changes
  Future<void> _saveProjectChanges() async {
    if (_isSubmitting) return;

    // Verify PIN first
    final pinVerified = await _showPinVerificationDialog();
    if (!pinVerified) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final provider = context.read<ProjectsProvider>();

      await provider.updateProject(
        projectRefId: widget.projectData!['project_ref_id'],
        clientId: _selectedClient?['client_ref_id']?.toString(),
        orderType: selectedOrderType,
        serviceCategoryId: _getCategoryForService(selectedServiceProject),
        status: widget.projectData!['status'],
        quotation: _fundsController.text.isNotEmpty ? _fundsController.text : null,
        pendingPayment: _recordPaymentController.text.isNotEmpty ? _recordPaymentController.text : null,
        tags: _beneficiaryController.text.isNotEmpty ? _beneficiaryController.text : null,
      );

      if (provider.errorMessage == null) {
        setState(() {
          _successMessage = provider.successMessage ?? 'Project updated successfully';
          _isEditMode = false;
        });

        // Refresh the projects list
        provider.getAllProjects();
      } else {
        setState(() {
          _errorMessage = provider.errorMessage;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  String? _getCategoryForService(String? serviceName) {
    if (serviceName == null) return null;
    final provider = context.read<ServiceCategoryProvider>();
    final service = provider.serviceCategories.firstWhere(
      (service) => service['service_name'] == serviceName,
      orElse: () => {},
    );
    return service['ref_id']?.toString();
  }

  void _selectedDateTime() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: CustomCupertinoCalendar(
            onDateTimeChanged: (date) {
              selectedDate = date;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _issueDateController.text =
                    "${selectedDate.day}-${selectedDate.month}-${selectedDate.year} "
                    "${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}";
                Navigator.pop(context); // close dialog
              },
              child: const Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Project Details",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            Text("Ref ID: ${widget.projectData?['project_ref_id'] ?? 'N/A'}"),
                          ],
                        ),
                        Row(
                          children: [
                            // Edit Mode Toggle Button
                            if (widget.projectData != null)
                              ElevatedButton.icon(
                                onPressed: _isSubmitting ? null : _toggleEditMode,
                                icon: Icon(_isEditMode ? Icons.lock : Icons.edit, size: 16),
                                label: Text(_isEditMode ? "Exit Edit" : "Edit"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isEditMode ? Colors.orange : Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () async {
                                // final shouldClose = await showDialog<bool>(
                                //   context: context,
                                //   builder:
                                //       (context) => AlertDialog(
                                //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                //         backgroundColor: Colors.white,
                                //         title: const Text("Are you sure?"),
                                //         content: const Text("Do you want to close this form? Unsaved changes may be lost."),
                                //         actions: [
                                //           TextButton(
                                //             onPressed: () => Navigator.of(context).pop(false),
                                //             child: const Text("Keep Changes ", style: TextStyle(color: Colors.blue)),
                                //           ),
                                //           TextButton(
                                //             onPressed: () => Navigator.of(context).pop(true),
                                //             child: const Text("Close", style: TextStyle(color: Colors.red)),
                                //           ),
                                //         ],
                                //       ),
                                // );
                                //
                                // if (shouldClose == true) {
                                Navigator.of(context).pop(); // close the dialog
                                // }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Error message display
                    if (_errorMessage != null)
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(child: Text(_errorMessage!, style: TextStyle(color: Colors.red))),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () => setState(() => _errorMessage = null),
                            ),
                          ],
                        ),
                      ),

                    // Success message display
                    if (_successMessage != null)
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Expanded(child: Text(_successMessage!, style: TextStyle(color: Colors.green))),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.green),
                              onPressed: () => setState(() => _successMessage = null),
                            ),
                          ],
                        ),
                      ),

                    // Edit mode indicator
                    if (_isEditMode)
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Edit Mode: You can now modify the project details. Click 'Save Changes' to save or 'Cancel' to discard changes.",
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_projectStatus == 'completed' || _projectStatus == 'stop')
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.lock, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "This project is finalized (Stopped/Completed). Further changes are disabled.",
                                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Input Fields Wrap
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildDateTimeField(),
                        Consumer<ClientProfileProvider>(
                          builder: (context, clientProvider, child) {
                            final clients = clientProvider.clients;
                            final clientNames =
                                clients
                                    .map((c) => (c['name'] ?? 'Unnamed').toString())
                                    .where((name) => name.isNotEmpty)
                                    .toList();

                            // Only set selectedValue if it exists in the options list
                            final validSelectedValue =
                                (searchClient != null && clientNames.contains(searchClient)) ? searchClient : null;

                            return CustomDropdownWithSearch(
                              label: "Search Client ",
                              selectedValue: validSelectedValue,
                              options: clientNames,
                              enabled: _isEditMode,
                              onChanged:
                                  _isEditMode
                                      ? (val) {
                                        setState(() {
                                          searchClient = val;
                                          _selectedClient = clients.firstWhere(
                                            (c) => (c['name'] ?? '').toString() == (val ?? ''),
                                            orElse: () => {},
                                          );
                                        });
                                      }
                                      : (val) {},
                            );
                          },
                        ),
                        CustomDropdownField(
                          label: "Order Type ",
                          selectedValue: selectedOrderType,
                          options: ["Services Base", " Project Base"],
                          enabled: _isEditMode,
                          onChanged:
                              _isEditMode
                                  ? (val) {
                                    setState(() => selectedOrderType = val);
                                  }
                                  : (val) {},
                        ),
                        Consumer<ServiceCategoryProvider>(
                          builder: (context, serviceProvider, child) {
                            final serviceOptions =
                                serviceProvider.serviceCategories
                                    .map((service) => service['service_name'].toString() ?? '')
                                    .where((name) => name.isNotEmpty)
                                    .toList();

                            // Only set selectedValue if it exists in the options list
                            final validSelectedValue =
                                (selectedServiceProject != null && serviceOptions.contains(selectedServiceProject))
                                    ? selectedServiceProject
                                    : null;

                            return CustomDropdownWithSearch(
                              label: "Service Project ",
                              selectedValue: validSelectedValue,
                              options: serviceOptions,
                              enabled: _isEditMode,
                              onChanged:
                                  _isEditMode
                                      ? (val) {
                                        setState(() {
                                          selectedServiceProject = val;
                                          // Auto-fill quotation and service provider when service is selected
                                          if (val != null) {
                                            final quotation = _getQuotationForService(val);
                                            final serviceProvider = _getServiceProviderForService(val);
                                            if (quotation != null) {
                                              _fundsController.text = quotation;
                                            }
                                            if (serviceProvider != null) {
                                              selectedServiceProvider = serviceProvider;
                                            }
                                          }
                                        });
                                      }
                                      : (val) {},
                            );
                          },
                        ),
                        Consumer<ServiceCategoryProvider>(
                          builder: (context, serviceProvider, child) {
                            final serviceProviderOptions =
                                serviceProvider.serviceCategories
                                    .map((service) => service['service_provider_name'].toString() ?? '')
                                    .where((name) => name.isNotEmpty)
                                    .toList();

                            // Only set selectedValue if it exists in the options list
                            final validSelectedValue =
                                (selectedServiceProvider != null &&
                                        serviceProviderOptions.contains(selectedServiceProvider))
                                    ? selectedServiceProvider
                                    : null;

                            return CustomDropdownWithSearch(
                              label: "Service Provider",
                              options: serviceProviderOptions,
                              selectedValue: validSelectedValue,
                              enabled: _isEditMode,
                              onChanged:
                                  _isEditMode
                                      ? (val) {
                                        setState(() => selectedServiceProvider = val);
                                      }
                                      : (val) {},
                            );
                          },
                        ),
                        /*CustomTextField(
                          label: "Service Beneficiary",
                          controller: _beneficiaryController,
                          hintText: "xyz",
                          enabled: _isEditMode,
                        ),*/
                        CustomTextField(
                          label: "Order Quote Price",
                          controller: _fundsController,
                          hintText: '500',
                          enabled: _isEditMode,
                        ),

                        /*Consumer<ProjectStageProvider>(
                          builder: (context, projectStageProvider, child) {
                            // Update the pending payment controller with the calculated value
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              final pendingAmount = calculatePendingPayment(_fundsController.text, widget.projectData?['paid_payment']);
                              if (_recordPaymentController.text != pendingAmount) {
                                _recordPaymentController.text = pendingAmount;
                              }
                            });

                            return CustomTextField(
                              label: "Pending Payment",
                              controller: _recordPaymentController,
                              hintText: '0',
                              enabled: false
                            );
                          },
                        ),*/
                        Consumer<ProjectStageProvider>(
                          builder: (context, projectStageProvider, child) {
                            final totalStepsCost = calculateTotalStepsCost();
                            final totalAdditionalProfit = calculateTotalAdditionalProfit();
                            final totalStepsReceivedAmount = calculateTotalStepsReceivedAmount();
                            final pendingAmount = calculatePendingPayment(
                              _fundsController.text,
                              widget.projectData?['paid_payment'],
                            );

                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                InfoBox(
                                  label: pendingAmount,
                                  value: 'Pending Amount',
                                  color: Colors.blue.shade200, // light blue fill
                                ),
                                InfoBox(
                                  label: totalStepsCost.toStringAsFixed(2),
                                  value: 'Total Steps Cost',
                                  color: Colors.blue.shade200, // light blue fill
                                ),
                                InfoBox(
                                  label: totalAdditionalProfit.toStringAsFixed(2),
                                  value: 'Total Additional Profit',
                                  color: Colors.blue.shade200, // light blue fill
                                ),
                                InfoBox(
                                  label: totalStepsReceivedAmount.toStringAsFixed(2),
                                  value: 'Total Steps Received Amount',
                                  color: Colors.blue.shade200, // light blue fill
                                ),
                              ],
                            );
                          },
                        ),
                        InfoBox(
                          label: widget.projectData?['user_id']?['name'] ?? 'N/A',
                          value: 'Assign Employee',
                          color: Colors.blue.shade200, // light blue fill
                        ),
                        InfoBox(
                          label: widget.projectData?['paid_payment'] ?? '0',
                          value: 'Received Funds',
                          color: Colors.blue.shade200, // light blue fill
                        ),
                        /*InfoBox(
                          label: widget.projectData?['project_ref_id'] ?? 'N/A',
                          value: 'Transaction Id',
                          color: Colors.yellow.shade100, // light blue fill
                        ),*/
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        if (_isEditMode) ...[
                          CustomButton(
                            text: _isSubmitting ? "Saving..." : "Save Changes",
                            backgroundColor: Colors.green,
                            onPressed: _isSubmitting ? () {} : _saveProjectChanges,
                          ),
                          const SizedBox(width: 10),
                          CustomButton(
                            text: "Cancel",
                            backgroundColor: Colors.grey,
                            onPressed: () {
                              setState(() {
                                _isEditMode = false;
                                _errorMessage = null;
                                _successMessage = null;
                              });
                              _initializeFormData();
                            },
                          ),
                        ] else if (_projectStatus == 'completed' || _projectStatus == 'stop') ...[
                          CustomButton(
                            text: "Reopen Project",
                            backgroundColor: Colors.green,
                            onPressed: () => _updateProjectStatus('in-progress'),
                          ),
                        ] else ...[
                          CustomButton(
                            text: "Stop",
                            backgroundColor: Colors.red,
                            onPressed: () => _updateProjectStatus('stop'),
                          ),
                          const SizedBox(width: 10),
                          CustomButton(
                            text: "Complete",
                            backgroundColor: Colors.blue,
                            onPressed: () => _updateProjectStatus('completed'),
                          ),
                        ],

                        const Spacer(), // Pushes the icon to the right
                        /*Material(
                          elevation: 8,
                          color: Colors.blue, // Set background color here
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: const Icon(
                              Icons.print,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Printed"),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.black87,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),*/
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<ProjectStageProvider>(
              builder: (context, projectStageProvider, child) {
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Title with Add Stage Button
                        Row(
                          children: [
                            Text(
                              "Project Stages (${projectStageProvider.projectStages.length})",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            Spacer(),
                            if (widget.projectData != null)
                              if (widget.projectData != null)
                                ElevatedButton.icon(
                                  onPressed: () => _showAddStageDialog(context),
                                  icon: Icon(Icons.add, size: 16),
                                  label: Text("Add Stage"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                            SizedBox(width: 10),
                            /*IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () async {
                                final shouldClose = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        backgroundColor: Colors.white,
                                        title: const Text("Are you sure?"),
                                        content: const Text("Do you want to close this form? Unsaved changes may be lost."),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text("Keep Changes ", style: TextStyle(color: Colors.blue)),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text("Close", style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                );

                                if (shouldClose == true) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),*/
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Success banner (independent of list)
                        if (projectStageProvider.successMessage != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    projectStageProvider.successMessage!,
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.green),
                                  onPressed: () => projectStageProvider.clearMessages(),
                                ),
                              ],
                            ),
                          ),

                        // Error banner (independent of list)
                        if (projectStageProvider.errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    projectStageProvider.errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => projectStageProvider.clearMessages(),
                                ),
                              ],
                            ),
                          ),

                        // CONTENT AREA
                        if (projectStageProvider.isLoading)
                          SizedBox(
                            height: 100,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Loading project stages...'),
                                ],
                              ),
                            ),
                          )
                        else if (projectStageProvider.projectStages.isNotEmpty)
                          ReorderableListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final item = projectStageProvider.projectStages.removeAt(oldIndex);
                                projectStageProvider.projectStages.insert(newIndex, item);

                                // Update stage numbers after reordering
                                for (var i = 0; i < projectStageProvider.projectStages.length; i++) {
                                  final stage = projectStageProvider.projectStages[i];
                                  stage['stage_number'] = i + 1;
                                }
                              });
                            },
                            children: projectStageProvider.projectStages.asMap().entries.map((entry) {
                              final stage = entry.value;
                              return KeyedSubtree(
                                key: ValueKey(stage['project_stage_ref_id']),
                                child: _buildStageCard(
                                  context,
                                  stage,
                                  entry.key + 1,
                                  projectStageProvider.isLastStage(stage['project_stage_ref_id']),
                                  projectStageProvider.isStageEnded(stage),
                                  projectStageProvider,
                                ),
                              );
                            }).toList(),
                          )
                        else
                          SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No project stages available',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add the first stage to get started',
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeField() {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        // onTap: _isEditMode ? _selectedDateTime : null,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "Date and Time",
            labelStyle: TextStyle(color: Colors.red),
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_month, color: Colors.red),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy – hh:mm a").format(selectedDateTime),
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ),
    );
  }

  /*
  Widget buildLabeledFieldWithHint({
    required String label,
    required String hint,
    required DateTime selectedDateTime,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.red),
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.red),
            helperText: hint,
            helperStyle: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          child: Text(
            DateFormat("dd-MM-yyyy – hh:mm a").format(selectedDateTime),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
*/

  Widget _field(String label, String value, {IconData? icon, Color? fillColor, TextStyle? style}) {
    return SizedBox(
      width: 220,
      child: TextFormField(
        cursorColor: Colors.blue,
        initialValue: value,
        style: style ?? const TextStyle(fontSize: 14),
        // 👈 Use it here
        readOnly: true,
        // Optional: make it non-editable
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red, fontSize: 16),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          suffixIcon: icon != null ? Icon(icon, color: Colors.red) : null,
          filled: fillColor != null,
          fillColor: fillColor,
        ),
      ),
    );
  }

  Widget _buildDropdown(String? label, String? selectedValue, List<String> options, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label?.isNotEmpty == true ? label : null,
          // ✅ optional label
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)),
        ),
        onChanged: onChanged,
        items:
            options
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 16))))
                .toList(),
      ),
    );
  }

  void showInstituteManagementDialog2(BuildContext context) {
    final List<String> institutes = [];
    final TextEditingController addController = TextEditingController();
    final TextEditingController editController = TextEditingController();
    int? editingIndex;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Slightly smaller radius
              ),
              contentPadding: const EdgeInsets.all(12), // Reduced padding
              insetPadding: const EdgeInsets.all(20), // Space around dialog
              content: SizedBox(
                width: 363,
                height: 305,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Compact header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Services',
                          style: TextStyle(
                            fontSize: 16, // Smaller font
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 25, color: Colors.red),
                          // Smaller icon
                          padding: EdgeInsets.zero,
                          // Remove default padding
                          constraints: const BoxConstraints(),
                          // Remove minimum size
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Compact input field
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // align top
                      children: [
                        // TextField
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
                                border: InputBorder.none, // remove double border
                                isDense: true,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Add Button
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            onPressed: () {
                              if (addController.text.trim().isNotEmpty) {
                                setState(() {
                                  institutes.add(addController.text.trim());
                                  addController.clear();
                                });
                              }
                            },
                            child: const Text("Add", style: TextStyle(fontSize: 14, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Compact list
                    Expanded(
                      child:
                          institutes.isEmpty
                              ? const Center(child: Text('No institutes', style: TextStyle(fontSize: 14)))
                              : ListView.builder(
                                shrinkWrap: true,
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
                                      // Makes tiles more compact
                                      visualDensity: VisualDensity.compact,
                                      // Even more compact
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                      title: Text(institutes[index], style: const TextStyle(fontSize: 14)),
                                      trailing: SizedBox(
                                        width: 80, // Constrained width for buttons
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, size: 18, color: Colors.green),
                                              padding: EdgeInsets.zero,
                                              onPressed:
                                                  () => _showEditDialog(
                                                    context,
                                                    setState,
                                                    institutes,
                                                    index,
                                                    editController,
                                                  ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
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
          },
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    StateSetter setState,
    List<String> institutes,
    int index,
    TextEditingController editController,
  ) {
    editController.text = institutes[index];
    showDialog(
      context: context,
      builder: (editContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            width: 250, // Smaller width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  cursorColor: Colors.blue,
                  controller: editController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Colors.grey)),
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
                      onPressed: () => Navigator.pop(editContext),
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        if (editController.text.trim().isNotEmpty) {
                          setState(() {
                            institutes[index] = editController.text.trim();
                          });
                          Navigator.pop(editContext);
                        }
                      },
                      text: 'Save',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build individual stage card
  Widget _buildStageCard(
    BuildContext context,
    Map<String, dynamic> stage,
    int stageNumber,
    bool isLastStage,
    bool isStageEnded,
    ProjectStageProvider provider,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: isStageEnded ? Colors.grey.shade50 : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stage Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isStageEnded ? Colors.grey : Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "Stage $stageNumber",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              SizedBox(width: 10),
              Text(
                "SID: ${stage['project_stage_ref_id'] ?? 'N/A'}",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Spacer(),
              if (!isStageEnded)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 18, color: Colors.blue),
                      onPressed: () => _showEditStageDialog(context, stage),
                    ),
                    /*IconButton(
                      icon: Icon(Icons.delete, size: 18, color: Colors.red),
                      onPressed: () => _deleteStage(context, stage, provider),
                    ),*/
                  ],
                ),
            ],
          ),
          SizedBox(height: 16),

          // Stage Content
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildDateTimeField(),
              // _buildDateTimeField(),
              InfoBox(
                label: stage['service_department'] ?? 'N/A',
                value: 'Services Department',
                color: Colors.orange.shade100,
              ),
            ],
          ),
          SizedBox(height: 10),

          // Applications Section
          if ((stage['applications'] != null && (stage['applications'] as List).isNotEmpty) ||
              (stage['application_ids'] != null && (stage['application_ids'] as List).isNotEmpty)) ...[
            Text("Application IDs", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (stage['applications'] != null && stage['applications'] is List)
                  ...(stage['applications'] as List).asMap().entries.map((entry) {
                    final appIndex = entry.key;
                    final app = entry.value;
                    final appId = app['application']?.toString() ?? app['id']?.toString() ?? '';
                    final appName = app['department']?.toString() ?? app['name']?.toString() ?? '';
                    return SizedBox(
                      width: 195,
                      child: InfoBox(
                        value: appName.isNotEmpty ? appName : "Application ${appIndex + 1}",
                        label: appId,
                        color: Colors.blue.shade100,
                      ),
                    );
                  })
                else if (stage['application_ids'] != null && stage['application_ids'] is List)
                  // Fallback for old format
                  ...(stage['application_ids'] as List).asMap().entries.map((entry) {
                    final appIndex = entry.key;
                    final appId = entry.value.toString();
                    return SizedBox(
                      width: 195,
                      child: InfoBox(
                        value: "Application ID-${appIndex + 1}",
                        label: appId,
                        color: Colors.blue.shade100,
                      ),
                    );
                  }),
                if (!isStageEnded)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextButton(
                      onPressed: () => _showAddApplicationDialog(context, stage, provider),
                      child: Text(
                        'Add Application',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
          ] else if (!isStageEnded) ...[
            TextButton(
              onPressed: () => _showAddApplicationDialog(context, stage, provider),
              child: Text(
                'Add Application',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(height: 10),
          ],

          // Extra Notes Section
          if (stage['extra_notes'] != null && (stage['extra_notes'] as List).isNotEmpty) ...[
            Text("Extra Notes", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ...(stage['extra_notes'] as List).asMap().entries.map((entry) {
                  final noteIndex = entry.key;
                  final note = entry.value;
                  final noteTitle = note['title']?.toString() ?? '';
                  final noteDescription = note['description']?.toString() ?? '';
                  return SizedBox(
                    width: 195,
                    child: InfoBox(
                      value: noteTitle.isNotEmpty ? noteTitle : "Note ${noteIndex + 1}",
                      label: noteDescription,
                      color: Colors.green.shade100,
                    ),
                  );
                }),
                if (!isStageEnded)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextButton(
                      onPressed: () => _showAddExtraNoteDialog(context, stage, provider),
                      child: Text(
                        'Add Extra Note',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
          ] else if (!isStageEnded) ...[
            TextButton(
              onPressed: () => _showAddExtraNoteDialog(context, stage, provider),
              child: Text(
                'Add Extra Note',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(height: 10),
          ],

          // Cost and Profit
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              InfoBoxNoColor(value: "Step Cost", label: stage['step_cost'] ?? "0"),
              InfoBoxNoColor(value: "Additional Profit", label: stage['additional_profit'] ?? "0"),

              /*CustomTextField(
                label: "Additional Profit",
                hintText: stage['additional_profit'] ?? "0",
                controller: TextEditingController(
                  text: stage['additional_profit'] ?? "0",
                ),
                enabled: !isStageEnded,
              ),*/
              InfoBoxNoColor(value: "Received Amount", label: stage['received_amount'] ?? "0"),
            ],
          ),
          SizedBox(height: 10),

          // Summary Info Boxes
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              /*InfoBox(
                label: stage['step_cost'] ?? "0",
                value: "Total Step Cost",
                color: Colors.blue.shade200,
              ),
              InfoBox(
                label: stage['additional_profit'] ?? "0",
                value: "Additional Profit",
                color: Colors.blue.shade200,
              ),*/
              InfoBox(
                value: "Stage Status",
                label: isStageEnded ? "Completed" : "In Progress",
                color: isStageEnded ? Colors.green.shade200 : Colors.orange.shade200,
              ),
              InfoBox(value: "End Date", label: stage['end_at'] ?? "Not Ended", color: Colors.yellow.shade100),
            ],
          ),

          // Action Buttons (show on any stage that is not ended)
          if (isStageEnded) ...[
            SizedBox(height: 20),
            Row(
              children: [
                CustomButton(
                  text: "Reopen Stage",
                  backgroundColor: Colors.green,
                  icon: Icons.refresh,
                  onPressed: () => _reopenStage(context, stage, provider),
                ),
                const Spacer(),
              ],
            ),
          ] else ...[
            SizedBox(height: 20),
            Row(
              children: [
                CustomButton(
                  text: "End Stage",
                  backgroundColor: Colors.red,
                  icon: Icons.lock_open_outlined,
                  onPressed: () => _endStage(context, stage, provider),
                ),
                const SizedBox(width: 10),
                CustomButton(
                  text: "Edit Stage",
                  backgroundColor: Colors.blue,
                  icon: Icons.lock_open,
                  onPressed: () async {
                    // Show PIN verification before opening edit dialog
                    await PinVerificationUtil.executeWithPinVerification(
                      context,
                      () => _showEditStageDialog(context, stage),
                      title: "Edit Stage",
                      message: "Please enter your PIN to edit this stage",
                    );
                  },
                ),
                const SizedBox(width: 10),
                // Show Add Next Stage button only on last stage
                if (isLastStage)
                  CustomButton(
                    text: "Add Next Stage",
                    backgroundColor: Colors.green,
                    onPressed: () => _showAddStageDialog(context),
                  ),
                if (isLastStage) const SizedBox(width: 10),

                const Spacer(),
                /*Material(
                  elevation: 8,
                  color: Colors.blue,
                  shape: const CircleBorder(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: IconButton(
                      icon: Icon(Icons.print, color: Colors.white, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Stage printed"),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.black87,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ),*/
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Show add stage dialog
  void _showAddStageDialog(BuildContext context) {
    final serviceDepartmentController = TextEditingController();
    final stepCostController = TextEditingController();
    final additionalProfitController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.white,
            title: Text("Add New Stage"),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(label: "Service Department", controller: serviceDepartmentController, hintText: ""),
                  SizedBox(height: 16),
                  CustomTextField(
                    label: "Step Cost",
                    controller: stepCostController,
                    hintText: "5000.00",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    label: "Additional Profit",
                    controller: additionalProfitController,
                    hintText: "1200.00",
                    keyboardType: TextInputType.number,
                  ),
                  /*SizedBox(height: 16),
                  CustomTextField(
                    label: "Application Names/Departments (comma separated)",
                    controller: applicationNamesController,
                    hintText: "",
                  ),
                  CustomTextField(
                    label: "Application IDs (comma separated)",
                    controller: applicationIdsController,
                    hintText: "APP-1, APP-2, APP-3",
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    label: "Extra Note Titles (comma separated)",
                    controller: extraNotesTitlesController,
                    hintText: "Note 1, Note 2",
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    label: "Extra Note Descriptions (comma separated)",
                    controller: extraNotesDescriptionsController,
                    hintText: "Description 1, Description 2",
                  ),*/
                  SizedBox(height: 16),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              CustomButton(
                text: "Add Stage",
                backgroundColor: Colors.green,
                onPressed: () async {
                  if (serviceDepartmentController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill required fields")));
                    return;
                  }


                  final provider = context.read<ProjectStageProvider>();
                  await provider.addProjectStage(
                    projectRefId: widget.projectData!['project_ref_id'],
                    serviceDepartment: serviceDepartmentController.text.trim(),
                    stepCost: stepCostController.text.trim(),
                    additionalProfit:
                        additionalProfitController.text.trim().isEmpty ? null : additionalProfitController.text.trim(),
                  );
                  // After adding a stage, move project to in-progress if not locked
                  if (!_isProjectLocked) {
                    await _updateProjectStatus('in-progress');
                  }

                  // Refresh calculations after adding stage
                  if (mounted) {
                    setState(() {});
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  /// Show edit stage dialog
  void _showEditStageDialog(BuildContext context, Map<String, dynamic> stage) {
    final stepCostController = TextEditingController(text: stage['step_cost'] ?? '');
    final additionalProfitController = TextEditingController(text: stage['additional_profit'] ?? '');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.white,
            title: Text("Edit Stage"),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InfoBoxNoColor(label: stage['service_department'] ?? 'N/A', value: 'Service Department (Read Only)'),
                  SizedBox(height: 16),
                  CustomTextField(
                    label: "Step Cost",
                    controller: stepCostController,
                    hintText: "5000.00",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    label: "Additional Profit",
                    controller: additionalProfitController,
                    hintText: "1200.00",
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              CustomButton(
                text: "Update Stage",
                backgroundColor: Colors.blue,
                onPressed: () async {
                  // Show PIN verification before updating
                  await PinVerificationUtil.executeWithPinVerification(
                    context,
                    () async {
                      final provider = context.read<ProjectStageProvider>();
                      await provider.updateProjectStage(
                        projectStageRefId: stage['project_stage_ref_id'],
                        stepCost: stepCostController.text.trim().isEmpty ? null : stepCostController.text.trim(),
                        additionalProfit:
                            additionalProfitController.text.trim().isEmpty ? null : additionalProfitController.text.trim(),
                      );
                      // After editing a stage, ensure project is in-progress if not locked
                      if (!_isProjectLocked) {
                        await _updateProjectStatus('in-progress');
                      }

                      // Refresh calculations after updating stage
                      if (mounted) {
                        setState(() {});
                      }

                      Navigator.pop(context);
                    },
                    title: "Update Stage",
                    message: "Please enter your PIN to update this stage",
                  );
                },
              ),
            ],
          ),
    );
  }

  /// Show add application dialog
  void _showAddApplicationDialog(BuildContext context, Map<String, dynamic> stage, ProjectStageProvider provider) {
    final applicationIdController = TextEditingController();
    final applicationNameController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.white,
            title: Text("Add Application"),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    label: "Application Name/Department",
                    controller: applicationNameController,
                    hintText: "",
                  ),
                  SizedBox(height: 16),
                  CustomTextField(label: "Application ID", controller: applicationIdController, hintText: ""),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              CustomButton(
                text: "Add",
                backgroundColor: Colors.green,
                onPressed: () async {
                  if (applicationIdController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter application ID")));
                    return;
                  }

                  // Get current applications
                  List<Map<String, String>> currentApplications = [];
                  if (stage['applications'] != null && stage['applications'] is List) {
                    for (final app in stage['applications']) {
                      if (app is Map<String, dynamic>) {
                        currentApplications.add({
                          "application": app['application']?.toString() ?? app['application']?.toString() ?? '',
                          "department": app['department']?.toString() ?? app['department']?.toString() ?? '',
                        });
                      }
                    }
                  } else if (stage['application_ids'] != null) {
                    // Fallback for old format
                    for (final id in stage['application_ids']) {
                      currentApplications.add({"application": id.toString(), "department": id.toString()});
                    }
                  }

                  // Add new application
                  currentApplications.add({
                    "application": applicationIdController.text.trim(),
                    "department":
                        applicationNameController.text.trim().isEmpty
                            ? applicationIdController.text.trim()
                            : applicationNameController.text.trim(),
                  });

                  await provider.updateProjectStage(
                    projectStageRefId: stage['project_stage_ref_id'],
                    applications: currentApplications,
                  );

                  // Refresh calculations after adding application
                  if (mounted) {
                    setState(() {});
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  /// Show add extra note dialog
  void _showAddExtraNoteDialog(BuildContext context, Map<String, dynamic> stage, ProjectStageProvider provider) {
    final noteTitleController = TextEditingController();
    final noteDescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.white,
            title: Text("Add Extra Note"),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(label: "Note Title", controller: noteTitleController, hintText: "Enter note title"),
                  SizedBox(height: 16),
                  CustomTextField(
                    label: "Note Description",
                    controller: noteDescriptionController,
                    hintText: "Enter note description",
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              CustomButton(
                text: "Add",
                backgroundColor: Colors.green,
                onPressed: () async {
                  if (noteTitleController.text.trim().isEmpty || noteDescriptionController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Please enter both title and description")));
                    return;
                  }

                  // Get current extra notes
                  List<Map<String, String>> currentExtraNotes = [];
                  if (stage['extra_notes'] != null && stage['extra_notes'] is List) {
                    for (final note in stage['extra_notes']) {
                      if (note is Map<String, dynamic>) {
                        currentExtraNotes.add({
                          "title": note['title']?.toString() ?? '',
                          "description": note['description']?.toString() ?? '',
                        });
                      }
                    }
                  }

                  // Add new note
                  currentExtraNotes.add({
                    "title": noteTitleController.text.trim(),
                    "description": noteDescriptionController.text.trim(),
                  });

                  await provider.updateProjectStage(
                    projectStageRefId: stage['project_stage_ref_id'],
                    extraNotes: currentExtraNotes,
                  );

                  // Refresh calculations after adding note
                  if (mounted) {
                    setState(() {});
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  /// End stage
  void _endStage(BuildContext context, Map<String, dynamic> stage, ProjectStageProvider provider) async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text("End Stage?"),
            content: Text("Are you sure you want to end this stage? This action cannot be undone."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("End Stage", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (shouldEnd == true) {
      final endTime = DateTime.now().toIso8601String().replaceAll('T', ' ').substring(0, 19);
      await provider.updateProjectStage(projectStageRefId: stage['project_stage_ref_id'], endAt: endTime);

      // Refresh calculations after ending stage
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// Reopen stage
  void _reopenStage(BuildContext context, Map<String, dynamic> stage, ProjectStageProvider provider) async {
    final shouldReopen = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text("Reopen Stage?"),
        content: Text("Are you sure you want to reopen this stage?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Reopen", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );

    if (shouldReopen == true) {
      await provider.updateProjectStage(
        projectStageRefId: stage['project_stage_ref_id'],
        endAt: null, // Set end_at to null to reopen the stage
      );

      // Refresh calculations after reopening stage
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// Delete stage
  void _deleteStage(BuildContext context, Map<String, dynamic> stage, ProjectStageProvider provider) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text("Delete Stage?"),
            content: Text("Are you sure you want to delete this stage? This action cannot be undone."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      await provider.deleteProjectStage(projectStageRefId: stage['project_stage_ref_id']);

      // Refresh calculations after deleting stage
      if (mounted) {
        setState(() {});
      }
    }
  }
}
