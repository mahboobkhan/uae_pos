import 'dart:convert';
import 'dart:io';

import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../providers/banking_payment_method_provider.dart';
import '../../../../providers/banking_payments_provider.dart';
import '../../../../providers/projects_provider.dart';
import '../../../../providers/project_stage_provider.dart';
import '../../../../providers/documents_provider.dart';
import '../../../dialogs/custom_fields.dart';

class DialogueBankTransaction extends StatefulWidget {
  final Map<String, dynamic>? paymentData;
  final bool isEditMode;

  const DialogueBankTransaction({super.key, this.paymentData, this.isEditMode = false});

  @override
  State<DialogueBankTransaction> createState() => _DialogueBankTransactionState();
}

class _DialogueBankTransactionState extends State<DialogueBankTransaction> {
  String? selectedBank;
  String? selectedPaymentType;
  String? selectedClientType;
  String? selectedProject;
  String? selectedPaymentMethod; // Cash, Cheque, Bank
  String? selectedProjectStage;
  String? selectedSubStage;

  Map<String, dynamic>? selectedProjectData; // Store full project data
  Map<String, dynamic>? selectedStageData; // Store selected stage data
  List<Map<String, dynamic>> subStages = [];

  // Document related variables
  List<String> uploadedDocumentIds = [];
  List<Map<String, dynamic>> transactionDocuments = [];
  dynamic selectedFile; // Use dynamic to handle both File and PlatformFile
  String? selectedFileName;
  Uint8List? selectedFileBytes; // For web compatibility
  bool _isProcessing = false;
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController documentIssueDateController = TextEditingController();
  final TextEditingController documentExpiryDateController = TextEditingController();

  // Payment types updated to new naming
  final List<String> paymentMethods = ['Cash', 'Cheque', 'Bank',];

  // payment type
  final List<String> paymentTypes = ['Receive', 'Return', 'Expense'];

  // Client types
  final List<String> clientTypes = ['Corporate', 'Individual', 'Government', 'Non-Profit', 'Startup'];

  late TextEditingController _amountController;
  late TextEditingController _searchController;
  late TextEditingController _paymentByController;
  late TextEditingController _receivedByController;
  late TextEditingController _serviceTIDController;
  late TextEditingController _noteController;
  late TextEditingController _stepCostController;
  late TextEditingController _additionalCostController;

  // Capitalize first letter helper
  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<String> getCurrentUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    return name ?? '';
  }

  // Check if project matches the selected client type
  bool _matchesClientType(Map<String, dynamic> project, String clientType) {
    // For now, we'll use a simple matching based on client name or project type
    // In a real implementation, you would check the actual client type field
    final clientName = project['client_id']?['name']?.toString().toLowerCase() ?? '';
    final projectType = project['project_type']?.toString().toLowerCase() ?? '';
    
    switch (clientType.toLowerCase()) {
      case 'corporate':
        return clientName.contains('corp') || 
               clientName.contains('ltd') || 
               clientName.contains('inc') ||
               projectType.contains('corporate');
      case 'individual':
        return !clientName.contains('corp') && 
               !clientName.contains('ltd') && 
               !clientName.contains('inc') &&
               !projectType.contains('corporate') &&
               !projectType.contains('government');
      case 'government':
        return clientName.contains('gov') || 
               clientName.contains('ministry') ||
               projectType.contains('government');
      case 'non-profit':
        return clientName.contains('foundation') || 
               clientName.contains('charity') ||
               projectType.contains('non-profit');
      case 'startup':
        return clientName.contains('startup') || 
               projectType.contains('startup');
      default:
        return true; // Show all projects if no specific match
    }
  }

  // Load default sub-stages for initial display
  void _loadDefaultSubStages() {
    // Load a comprehensive list of all possible sub-stages
    subStages = [
      {'name': 'Initial Design', 'sub_stage_ref_id': 'design_1'},
      {'name': 'Design Review', 'sub_stage_ref_id': 'design_2'},
      {'name': 'Final Design', 'sub_stage_ref_id': 'design_3'},
      {'name': 'Backend Development', 'sub_stage_ref_id': 'dev_1'},
      {'name': 'Frontend Development', 'sub_stage_ref_id': 'dev_2'},
      {'name': 'Testing', 'sub_stage_ref_id': 'dev_3'},
      {'name': 'Deployment', 'sub_stage_ref_id': 'dev_4'},
      {'name': 'Initial Consultation', 'sub_stage_ref_id': 'consult_1'},
      {'name': 'Analysis', 'sub_stage_ref_id': 'consult_2'},
      {'name': 'Recommendations', 'sub_stage_ref_id': 'consult_3'},
      {'name': 'Phase 1', 'sub_stage_ref_id': 'phase_1'},
      {'name': 'Phase 2', 'sub_stage_ref_id': 'phase_2'},
      {'name': 'Phase 3', 'sub_stage_ref_id': 'phase_3'},
    ];
  }

  // Load sub-stages for the selected project stage
  void _loadSubStages(Map<String, dynamic> stageData) {
    // For now, we'll create some mock sub-stages based on the stage
    // In a real implementation, you would fetch these from your API
    final stageName = stageData['service_department'] ?? 'Unknown Department';
    
    // Create mock sub-stages based on the stage type
    switch (stageName.toLowerCase()) {
      case 'design':
        subStages = [
          {'name': 'Initial Design', 'sub_stage_ref_id': 'design_1'},
          {'name': 'Design Review', 'sub_stage_ref_id': 'design_2'},
          {'name': 'Final Design', 'sub_stage_ref_id': 'design_3'},
        ];
        break;
      case 'development':
        subStages = [
          {'name': 'Backend Development', 'sub_stage_ref_id': 'dev_1'},
          {'name': 'Frontend Development', 'sub_stage_ref_id': 'dev_2'},
          {'name': 'Testing', 'sub_stage_ref_id': 'dev_3'},
          {'name': 'Deployment', 'sub_stage_ref_id': 'dev_4'},
        ];
        break;
      case 'consulting':
        subStages = [
          {'name': 'Initial Consultation', 'sub_stage_ref_id': 'consult_1'},
          {'name': 'Analysis', 'sub_stage_ref_id': 'consult_2'},
          {'name': 'Recommendations', 'sub_stage_ref_id': 'consult_3'},
        ];
        break;
      default:
        subStages = [
          {'name': 'Phase 1', 'sub_stage_ref_id': 'phase_1'},
          {'name': 'Phase 2', 'sub_stage_ref_id': 'phase_2'},
          {'name': 'Phase 3', 'sub_stage_ref_id': 'phase_3'},
        ];
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode && widget.paymentData != null) {
      // Edit mode - populate with existing data
      _searchController = TextEditingController();
      _amountController = TextEditingController(text: widget.paymentData!['total_amount']?.toString() ?? '');
      _paymentByController = TextEditingController(text: widget.paymentData!['pay_by']?.toString() ?? '');
      _receivedByController = TextEditingController(
        text: widget.paymentData!['received_by']?.toString() ?? getCurrentUserName().toString(),
      );
      _serviceTIDController = TextEditingController(text: widget.paymentData!['transaction_id']?.toString() ?? '');
      _noteController = TextEditingController(text: widget.paymentData!['note']?.toString() ?? '');

      // Set initial values
      selectedPaymentType = capitalizeFirstLetter(widget.paymentData!['payment_type']?.toString());
      selectedPaymentMethod = capitalizeFirstLetter(widget.paymentData!['payment_method']?.toString());

      print("payment type $selectedPaymentType,  payment method $selectedPaymentMethod");

      selectedBank = widget.paymentData!['bank_ref_id']?.toString();

      // Set project data if available
      if (widget.paymentData!['type_ref'] != null) {
        selectedProject = widget.paymentData!['type_ref']?.toString();
        // Create mock project data for display
        selectedProjectData = {
          'project_ref_id': widget.paymentData!['type_ref'],
          'client_id': {'client_ref_id': widget.paymentData!['client_ref'], 'name': 'Client from Payment Data'},
        };
      }
    } else {
      // Add mode - default values
      _searchController = TextEditingController();
      _amountController = TextEditingController();
      _paymentByController = TextEditingController();
      _receivedByController = TextEditingController();
      _serviceTIDController = TextEditingController();
      _noteController = TextEditingController();
      _stepCostController = TextEditingController();
      _additionalCostController = TextEditingController();

      // Set default username for received by
      getCurrentUserName().then((name) {
        if (mounted) {
          _receivedByController.text = name;
        }
      });
    }

    // Load data when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final paymentMethodProvider = context.read<BankingPaymentMethodProvider>();
        final projectsProvider = context.read<ProjectsProvider>();
        paymentMethodProvider.getAllPaymentMethods();
        projectsProvider.getAllProjects();
        
        // Load default sub-stages for the sub-stage dropdown
        _loadDefaultSubStages();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paymentByController.dispose();
    _receivedByController.dispose();
    _serviceTIDController.dispose();
    _noteController.dispose();
    _stepCostController.dispose();
    _additionalCostController.dispose();
    documentNameController.dispose();
    documentIssueDateController.dispose();
    documentExpiryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEditMode ? "Edit Banking Payment" : "Client Transactions",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.isEditMode ? "Ref: ${widget.paymentData?['payment_ref_id'] ?? 'N/A'}" : '',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _formattedDate(),
                        style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
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
              // First Row - Payment Type and Direction
              Row(
                children: [
                  Expanded(
                    child: CustomDropdownField(
                      label: "Payment Method",
                      selectedValue: selectedPaymentMethod,
                      options: paymentMethods,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value;
                          // Reset bank and service TID when changing payment type
                          if (value != 'Bank') {
                            selectedBank = null;
                            _serviceTIDController.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDropdownField(
                      label: "Payment Type",
                      selectedValue: selectedPaymentType,
                      options: paymentTypes,
                      onChanged: (value) => setState(() => selectedPaymentType = value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: CustomTextField(label: "Amount", controller: _amountController, hintText: '300')),
                ],
              ),
              const SizedBox(height: 15),
              // Single Row - Client Type, Project, and Project Stage Selection
              Row(
                children: [
                  // Client Type Selection
                  Expanded(
                    child: CustomDropdownField(
                      label: "Client Type",
                      selectedValue: selectedClientType,
                      options: [
                        'Select Client Type',
                        ...clientTypes,
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedClientType = value == 'Select Client Type' ? null : value;
                          selectedProject = null; // Reset project when client type changes
                          selectedProjectStage = null; // Reset stage when client type changes
                          selectedSubStage = null; // Reset sub-stage when client type changes
                          selectedProjectData = null;
                          selectedStageData = null;
                          subStages.clear(); // Clear sub-stages when client type changes
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Project Selection (only show if client type is selected)
                  if (selectedClientType != null) ...[
                    Expanded(
                      flex: 2,
                      child: Consumer<ProjectsProvider>(
                        builder: (context, projectsProvider, child) {
                          // Filter projects based on selected client type
                          final projects = projectsProvider.projects
                              .where((project) => 
                                  project['project_ref_id']?.toString().isNotEmpty == true &&
                                  _matchesClientType(project, selectedClientType!))
                              .toList();

                          return CustomDropdownField(
                            label: "Select Project",
                            selectedValue: selectedProject,
                            options: [
                              'Select Project',
                              ...projects.map(
                                (p) => '${p['project_ref_id']} - ${p['client_id']?['name'] ?? 'Unknown Client'}',
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedProject = value == 'Select Project' ? null : value;
                                selectedProjectStage = null; // Reset stage when project changes
                                selectedStageData = null;
                                selectedSubStage = null; // Reset sub-stage when project changes
                                subStages.clear(); // Clear sub-stages when project changes
                                if (value != null && value != 'Select Project') {
                                  // Find and store the full project data
                                  selectedProjectData = projects.firstWhere(
                                    (p) =>
                                        '${p['project_ref_id']} - ${p['client_id']?['name'] ?? 'Unknown Client'}' ==
                                        value,
                                    orElse: () => {},
                                  );
                                  // Auto-fill payment by with client name
                                  if (selectedProjectData != null && selectedProjectData!['client_id']?['name'] != null) {
                                    _paymentByController.text = selectedProjectData!['client_id']['name'];
                                  }
                                  // Load project stages when project is selected
                                  if (selectedProjectData != null) {
                                    final projectStageProvider = context.read<ProjectStageProvider>();
                                    projectStageProvider.getStagesByProject(
                                      projectRefId: selectedProjectData!['project_ref_id']?.toString() ?? '',
                                    );
                                  }
                                } else {
                                  selectedProjectData = null;
                                  // Clear payment by when no project is selected
                                  _paymentByController.clear();
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  // Project Stage Selection (only show if project is selected)
                  if (selectedProject != null) ...[
                    Expanded(
                      child: Consumer<ProjectStageProvider>(
                        builder: (context, projectStageProvider, child) {
                          // Filter stages that are not ended
                          // final activeStages =
                          //     projectStageProvider.projectStages.where((stage) => stage['end_at'] == null).toList();
                          final activeStages = projectStageProvider.projectStages.toList();

                          return CustomDropdownField(
                            label: "Project Stage",
                            selectedValue: selectedProjectStage,
                            options: [
                              'Select Stage',
                              ...activeStages.map((stage) => '${stage['service_department'] ?? 'Unknown Department'}'),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedProjectStage = value == 'Select Stage' ? null : value;
                                selectedSubStage = null; // Reset sub-stage when stage changes
                                subStages.clear(); // Clear sub-stages when stage changes
                                if (value != null && value != 'Select Stage') {
                                  selectedStageData = activeStages.firstWhere(
                                    (stage) => '${stage['service_department'] ?? 'Unknown Department'}' == value,
                                    orElse: () => {},
                                  );
                                  // Auto-fill step cost if available
                                  if (selectedStageData != null && selectedStageData!['step_cost'] != null) {
                                    _stepCostController.text = selectedStageData!['step_cost'].toString();
                                  }
                                  // Load sub-stages for the selected stage
                                  if (selectedStageData != null) {
                                    _loadSubStages(selectedStageData!);
                                  }
                                } else {
                                  selectedStageData = null;
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 15),
              // Third Row - Payment Details
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(label: "Payment By", controller: _paymentByController, hintText: "Client"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      label: "Received By",
                      controller: _receivedByController,
                      hintText: 'Manager',
                      enabled: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Show Step Cost and Additional Profit fields only for Expense type
              if (selectedPaymentType == 'Expense') ...[
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(label: "Step Cost", controller: _stepCostController, hintText: '0.00'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: "Additional Profits",
                        controller: _additionalCostController,
                        hintText: '0.00',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
              // Fifth Row - Bank/Cheque Details (conditional)
              if (selectedPaymentMethod == 'Bank') ...[
                Row(
                  children: [
                    Expanded(
                      child: Consumer<BankingPaymentMethodProvider>(
                        builder: (context, paymentMethodProvider, child) {
                          final banks =
                              paymentMethodProvider.paymentMethods
                                  .map((pm) => pm['bank_name']?.toString() ?? '')
                                  .where((name) => name.isNotEmpty)
                                  .toSet()
                                  .toList();

                          return CustomDropdownField(
                            label: 'Select Bank',
                            selectedValue: selectedBank,
                            options: ['Select Bank', ...banks],
                            onChanged: (value) {
                              setState(() {
                                selectedBank = value == 'Select Bank' ? null : value;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: "Service TID",
                        controller: _serviceTIDController,
                        hintText: 'Bank Transaction ID',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
              // Cheque No (only show when payment type is Cheque)
              if (selectedPaymentMethod == 'Cheque') ...[
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "Cheque No",
                        controller: _serviceTIDController,
                        hintText: 'Cheque No',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
              // Sixth Row - Note
              Row(
                children: [
                  Expanded(child: CustomTextField(label: "Note", controller: _noteController, hintText: 'xxxx')),
                ],
              ),
              const SizedBox(height: 15),
              
              // Document Upload Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Document Upload',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        CustomTextField(
                          label: "Document Name",
                          controller: documentNameController,
                          hintText: "e.g., Invoice Receipt",
                        ),
                        CustomDateNotificationField(
                          label: "Issue Date",
                          controller: documentIssueDateController,
                          readOnly: true,
                          hintText: "yyyy-MM-dd",
                          onTap: () => _pickDocumentDate(documentIssueDateController),
                        ),
                        CustomDateNotificationField(
                          label: "Expiry Date",
                          controller: documentExpiryDateController,
                          readOnly: true,
                          hintText: "yyyy-MM-dd",
                          onTap: () => _pickDocumentDate(documentExpiryDateController),
                        ),
                        Consumer<DocumentsProvider>(
                          builder: (context, documentsProvider, child) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: (documentsProvider.isUploading || _isProcessing)
                                          ? null
                                          : () {
                                              Future.microtask(() {
                                                _handleDocumentAction();
                                              });
                                            },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: (documentsProvider.isUploading || _isProcessing)
                                              ? Colors.grey
                                              : _getDocumentButtonColor(),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        constraints: const BoxConstraints(minWidth: 150, minHeight: 38),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (documentsProvider.isUploading)
                                              const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              )
                                            else
                                              Icon(_getDocumentButtonIcon(), size: 16, color: Colors.white),
                                            const SizedBox(width: 6),
                                            Text(
                                              _getDocumentButtonText(),
                                              style: const TextStyle(fontSize: 14, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (documentsProvider.isUploading)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: IconButton(
                                          onPressed: () {
                                            documentsProvider.resetLoadingState();
                                            setState(() {
                                              selectedFile = null;
                                              selectedFileName = null;
                                              selectedFileBytes = null;
                                            });
                                          },
                                          icon: const Icon(Icons.close, color: Colors.red),
                                          tooltip: 'Cancel Upload',
                                        ),
                                      ),
                                  ],
                                ),
                                if (documentsProvider.isUploading)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: LinearProgressIndicator(
                                      value: documentsProvider.uploadProgress,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    if (selectedFileName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selected: $selectedFileName',
                          style: const TextStyle(fontSize: 12, color: Colors.green),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Document List Section
              if (transactionDocuments.isNotEmpty || uploadedDocumentIds.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attached Documents',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          // Existing documents
                          ...transactionDocuments.map(
                            (doc) => _buildDocumentItem(
                              name: doc['name'] ?? 'Unknown Document',
                              issueDate: doc['issue_date'] ?? '',
                              expiryDate: doc['expire_date'] ?? '',
                              documentRefId: doc['document_ref_id'] ?? '',
                              isExisting: true,
                              url: doc['url'],
                            ),
                          ),
                          
                          // Newly uploaded documents
                          ...uploadedDocumentIds.map(
                            (docId) => _buildDocumentItem(
                              name: 'New Document',
                              issueDate: '',
                              expiryDate: '',
                              documentRefId: docId,
                              isExisting: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomButton(
                    onPressed: () {
                      _clearForm();
                    },
                    text: "Clear",
                    backgroundColor: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Consumer<BankingPaymentsProvider>(
                    builder: (context, bankingProvider, child) {
                      return CustomButton(
                        onPressed:
                            bankingProvider.isLoading
                                ? () {}
                                : () {
                                  widget.isEditMode ? _updatePayment() : _submitForm();
                                },
                        text:
                            bankingProvider.isLoading
                                ? (widget.isEditMode ? "Updating..." : "Submitting...")
                                : (widget.isEditMode ? "Update" : "Submit"),
                        backgroundColor: Colors.green,
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

  String _formattedDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
  }

  void _clearForm() {
    setState(() {
      selectedBank = null;
      selectedPaymentType = null;
      selectedClientType = null;
      selectedProject = null;
      selectedPaymentMethod = null;
      selectedProjectStage = null;
      selectedSubStage = null;
      selectedProjectData = null;
      selectedStageData = null;
      subStages.clear();
      _amountController.clear();
      _searchController.clear();
      _paymentByController.clear();
      _receivedByController.clear();
      _serviceTIDController.clear();
      _noteController.clear();
      _stepCostController.clear();
      _additionalCostController.clear();
      // Clear document fields
      selectedFile = null;
      selectedFileName = null;
      selectedFileBytes = null;
      uploadedDocumentIds.clear();
      transactionDocuments.clear();
      documentNameController.clear();
      documentIssueDateController.clear();
      documentExpiryDateController.clear();
    });
  }

  void _submitForm() async {
    // Validate required fields
    if (selectedPaymentMethod == null || selectedPaymentType == null || selectedClientType == null || selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    // Validate project stage selection if payment type is Receive
    if (selectedPaymentType == 'Receive' && selectedProjectStage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select project stage for Receive payment type')));
      return;
    }

    // Validate bank selection if payment method is Bank
    if (selectedPaymentMethod == 'Bank' && selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a bank for bank payment')));
      return;
    }

    if (_amountController.text.isEmpty || _paymentByController.text.isEmpty || _receivedByController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    // Submit the form
    final bankingProvider = context.read<BankingPaymentsProvider>();

    // Extract project ref ID and client ref ID from selected project data
    final projectRefId = selectedProjectData?['project_ref_id']?.toString() ?? selectedProject!;
    final clientRefId = selectedProjectData?['client_id']?['client_ref_id']?.toString() ?? '';

    // Map payment type to in/out
    String paymentTypeValue = selectedPaymentType == 'Receive' ? 'in' : 'out';

    final double? stepCostVal = (selectedPaymentType == 'Expense' && _stepCostController.text.isNotEmpty)
        ? double.tryParse(_stepCostController.text)
        : null;
    final double? additionalProfitVal = (selectedPaymentType == 'Expense' && _additionalCostController.text.isNotEmpty)
        ? double.tryParse(_additionalCostController.text)
        : null;

    await bankingProvider.addBankingPayment(
      type: 'project',
      typeRef: projectRefId,
      clientRef: clientRefId,
      // Using actual client ref ID from project data
      paymentType: paymentTypeValue,
      payBy: _paymentByController.text,
      receivedBy: _receivedByController.text,
      totalAmount: amount,
      paidAmount: amount,
      status: 'completed',
      paymentMethod: selectedPaymentMethod!.toLowerCase(),
      transactionId: _serviceTIDController.text.isNotEmpty ? _serviceTIDController.text : null,
      bankRefId: selectedBank,
      chequeNo:
          selectedPaymentMethod == 'Cheque' && _serviceTIDController.text.isNotEmpty
              ? _serviceTIDController.text
              : null,
      stepCost: stepCostVal,
      additionalProfit: additionalProfitVal,
      projectStageRefId: selectedStageData?['project_stage_ref_id']?.toString(),
      // Note: projectSubStageRefId parameter not yet supported in provider
      // TODO: Add projectSubStageRefId parameter to addBankingPayment method
    );

    // Check if submission was successful
    if (bankingProvider.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(bankingProvider.successMessage!)));
      _clearForm();
      Navigator.of(context).pop();
    } else if (bankingProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(bankingProvider.errorMessage!)));
    }
  }

  void _updatePayment() async {
    // Validate required fields
    if (selectedPaymentMethod == null || selectedPaymentType == null || selectedClientType == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    // Validate project stage selection if payment type is Receive
    if (selectedPaymentType == 'Receive' && selectedProjectStage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select project stage for Receive payment type')));
      return;
    }

    // Validate bank selection if payment method is Bank
    if (selectedPaymentMethod == 'Bank' && selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a bank for bank payment')));
      return;
    }

    if (_amountController.text.isEmpty || _paymentByController.text.isEmpty || _receivedByController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    // Update the payment
    final bankingProvider = context.read<BankingPaymentsProvider>();

    // Map payment type to in/out
    String paymentTypeValue = selectedPaymentType == 'Receive' ? 'in' : 'out';

    final double? stepCostUpdateVal = (selectedPaymentType == 'Expense' && _stepCostController.text.isNotEmpty)
        ? double.tryParse(_stepCostController.text)
        : null;
    final double? additionalCostUpdateVal = (selectedPaymentType == 'Expense' && _additionalCostController.text.isNotEmpty)
        ? double.tryParse(_additionalCostController.text)
        : null;

    await bankingProvider.updateBankingPayment(
      id: widget.paymentData!['id']?.toString(),
      paymentRefId: widget.paymentData!['payment_ref_id']?.toString(),
      paymentType: paymentTypeValue,
      payBy: _paymentByController.text,
      receivedBy: _receivedByController.text,
      totalAmount: amount,
      paidAmount: amount,
      status: 'completed',
      paymentMethod: selectedPaymentMethod!.toLowerCase(),
      transactionId: _serviceTIDController.text.isNotEmpty ? _serviceTIDController.text : null,
      bankRefId: selectedBank,
      chequeNo:
          selectedPaymentMethod == 'Cheque' && _serviceTIDController.text.isNotEmpty
              ? _serviceTIDController.text
              : null,
      // Include step/additional only for Expense type
      stepCost: stepCostUpdateVal,
      additionalCost: additionalCostUpdateVal,
      projectStageRefId: selectedStageData?['project_stage_ref_id']?.toString(),
      // Note: projectSubStageRefId parameter not yet supported in provider
      // TODO: Add projectSubStageRefId parameter to updateBankingPayment method
    );

    // Check if update was successful
    if (bankingProvider.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(bankingProvider.successMessage!)));
      Navigator.of(context).pop();
    } else if (bankingProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(bankingProvider.errorMessage!)));
    }
  }

  // Document related methods
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'tif'],
        allowMultiple: false,
        withData: true,
        withReadStream: false,
        allowCompression: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        setState(() {
          if (kIsWeb) {
            selectedFile = file;
            selectedFileBytes = file.bytes;
            selectedFileName = file.name;
          } else {
            if (file.path != null && file.path!.isNotEmpty) {
              selectedFile = File(file.path!);
              selectedFileName = file.name;
            }
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File selected: ${file.name}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('File picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _uploadDocument() async {
    if (_isProcessing) return;

    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a file first')));
      return;
    }

    if (documentNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter document name')));
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(milliseconds: 100));

    final documentsProvider = context.read<DocumentsProvider>();
    String? documentRefId;

    try {
      if (kIsWeb) {
        if (selectedFileBytes != null) {
          documentRefId = await documentsProvider.addDocumentWeb(
            name: documentNameController.text.trim(),
            issueDate: documentIssueDateController.text.trim().isNotEmpty
                ? documentIssueDateController.text.trim()
                : DateFormat('yyyy-MM-dd').format(DateTime.now()),
            expireDate: documentExpiryDateController.text.trim().isNotEmpty
                ? documentExpiryDateController.text.trim()
                : DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 365))),
            fileBytes: selectedFileBytes!,
            fileName: selectedFileName ?? 'document',
          );
        }
      } else {
        if (selectedFile is File) {
          documentRefId = await documentsProvider.addDocument(
            name: documentNameController.text.trim(),
            issueDate: documentIssueDateController.text.trim().isNotEmpty
                ? documentIssueDateController.text.trim()
                : DateFormat('yyyy-MM-dd').format(DateTime.now()),
            expireDate: documentExpiryDateController.text.trim().isNotEmpty
                ? documentExpiryDateController.text.trim()
                : DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 365))),
            file: selectedFile as File,
          );
        }
      }

      if (documentRefId != null) {
        if (mounted) {
          setState(() {
            uploadedDocumentIds.add(documentRefId!);
            selectedFile = null;
            selectedFileName = null;
            selectedFileBytes = null;
            documentNameController.clear();
            documentIssueDateController.clear();
            documentExpiryDateController.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Document uploaded successfully: $documentRefId'), backgroundColor: Colors.green),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(documentsProvider.errorMessage ?? 'Failed to upload document'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Upload failed: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _handleDocumentAction() {
    if (selectedFile == null) {
      _pickFile();
    } else if (documentNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter document name')));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _uploadDocument();
      });
    }
  }

  Color _getDocumentButtonColor() {
    if (selectedFile == null) {
      return Colors.blue; // Select Document
    } else if (documentNameController.text.trim().isEmpty) {
      return Colors.orange; // Enter name
    } else {
      return Colors.green; // Upload
    }
  }

  IconData _getDocumentButtonIcon() {
    if (selectedFile == null) {
      return Icons.attach_file; // Select Document
    } else if (documentNameController.text.trim().isEmpty) {
      return Icons.edit; // Enter name
    } else {
      return Icons.upload; // Upload
    }
  }

  String _getDocumentButtonText() {
    if (selectedFile == null) {
      return 'Select Document';
    } else if (documentNameController.text.trim().isEmpty) {
      return 'Enter Name';
    } else {
      return 'Upload';
    }
  }

  void _pickDocumentDate(TextEditingController controller) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).then((date) {
      if (date != null) {
        controller.text = DateFormat('yyyy-MM-dd').format(date);
      }
    });
  }

  Widget _buildDocumentItem({
    required String name,
    required String issueDate,
    required String expiryDate,
    required String documentRefId,
    required bool isExisting,
    String? url,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: isExisting ? Colors.blue : Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (issueDate.isNotEmpty || expiryDate.isNotEmpty)
                  Text(
                    'Issue: $issueDate | Expiry: $expiryDate',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                Text('ID: $documentRefId', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _downloadDocument(documentRefId, url: url),
                icon: const Icon(Icons.download, color: Colors.blue, size: 20),
                tooltip: 'Download Document',
              ),
              IconButton(
                onPressed: () => _deleteDocument(documentRefId),
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                tooltip: 'Delete Document',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _downloadDocument(String documentRefId, {String? url}) {
    final downloadUrl = url ?? 'No URL available';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading document: $documentRefId\nURL: $downloadUrl'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _deleteDocument(String documentRefId) async {
    final documentsProvider = context.read<DocumentsProvider>();
    final success = await documentsProvider.deleteDocument(documentRefId: documentRefId);

    if (success) {
      setState(() {
        transactionDocuments.removeWhere((doc) => doc['document_ref_id'] == documentRefId);
        uploadedDocumentIds.remove(documentRefId);
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document deleted successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(documentsProvider.errorMessage ?? 'Failed to delete document'),
        ),
      );
    }
  }


}

void showBankTransactionDialog(BuildContext context) {
  showDialog(context: context, barrierDismissible: false, builder: (context) => const DialogueBankTransaction());
}

