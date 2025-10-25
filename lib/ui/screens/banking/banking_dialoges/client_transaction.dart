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
  
  // Store attached files for upload
  List<Map<String, dynamic>> attachedFiles = []; // Store file references for upload

  // Payment types updated to new naming
  final List<String> paymentMethods = ['Select payment method','Cash', 'Cheque', 'Bank',];
  // payment type
  final List<String> paymentTypes = ['Select payment type','Receive', 'Return', 'Expense'];

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
          child: SingleChildScrollView(
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
                          selectedPaymentMethod = value =='Select payment method'?null:value;
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
                      onChanged: (value) => setState(() => selectedPaymentType = value=='Select payment type'?null:value),
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
              
              // Document Upload Section (only show when payment method is Bank)
              if (selectedPaymentMethod == 'Bank') ...[
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
                      
                      // Select Document Button
                        Consumer<DocumentsProvider>(
                          builder: (context, documentsProvider, child) {
                          // Check if a file is already attached
                          final hasAttachedFile = transactionDocuments.isNotEmpty || uploadedDocumentIds.isNotEmpty;
                          
                            return Column(
                                  children: [
                                    GestureDetector(
                                onTap: (documentsProvider.isUploading || _isProcessing || hasAttachedFile)
                                          ? null
                                          : () {
                                        print('🔍 Debug: Select Document button tapped');
                                              Future.microtask(() {
                                          _pickFile();
                                              });
                                            },
                                      child: Container(
                                        decoration: BoxDecoration(
                                    color: (documentsProvider.isUploading || _isProcessing || hasAttachedFile)
                                              ? Colors.grey
                                        : Colors.blue,
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
                                        const Icon(Icons.attach_file, size: 16, color: Colors.white),
                                            const SizedBox(width: 6),
                                            Text(
                                        documentsProvider.isUploading 
                                            ? 'Uploading...' 
                                            : hasAttachedFile 
                                                ? 'File Attached' 
                                                : 'Select Document',
                                              style: const TextStyle(fontSize: 14, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
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
                    
                    // Selected Document Preview
                    if (selectedFileName != null) ...[
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.description, color: Colors.blue, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedFileName!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    'File selected',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _previewDocument(),
                                  icon: const Icon(Icons.visibility, color: Colors.blue, size: 20),
                                  tooltip: 'Preview Document',
                                ),
                                IconButton(
                                  onPressed: () => _removeSelectedFile(),
                                  icon: const Icon(Icons.close, color: Colors.red, size: 20),
                                  tooltip: 'Remove File',
                      ),
                  ],
                ),
                          ],
                        ),
                      ),
                    ],
                    
                    // Attach Button (only show when file is selected)
                    if (selectedFileName != null) ...[
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: _isProcessing ? null : () {
                          print('🔍 Debug: Attach button tapped');
                          _attachDocument();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isProcessing ? Colors.grey : Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          constraints: const BoxConstraints(minWidth: 120, minHeight: 38),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isProcessing)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              else
                                const Icon(Icons.attach_file, size: 16, color: Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                _isProcessing ? 'Attaching...' : 'Attach',
                                style: const TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ],
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
              ],
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomButton(
                    onPressed: () {
                      print('🔍 Debug: Clear button pressed');
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
                                ? () {
                                    print('🔍 Debug: Submit button disabled - provider is loading');
                                  }
                                : () {
                                    print('🔍 Debug: Submit button pressed');
                                    print('🔍 Debug: Edit mode: ${widget.isEditMode}');
                                    if (widget.isEditMode) {
                                      print('🔍 Debug: Calling _updatePayment()');
                                      _updatePayment();
                                    } else {
                                      print('🔍 Debug: Calling _submitForm()');
                                      _submitForm();
                                    }
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
      attachedFiles.clear();
    });
  }
  void _submitForm() async {
    print('🔍 Debug: _submitForm() started');
    
    // Step 1️⃣: Basic validation
    if (selectedPaymentMethod == null ||
        selectedPaymentType == null ||
        selectedClientType == null ||
        selectedProject == null) {
      print('🔍 Debug: Validation failed - missing required fields');
      print('🔍 Debug: selectedPaymentMethod: $selectedPaymentMethod');
      print('🔍 Debug: selectedPaymentType: $selectedPaymentType');
      print('🔍 Debug: selectedClientType: $selectedClientType');
      print('🔍 Debug: selectedProject: $selectedProject');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Step 2️⃣: Project stage validation (Receive only)
    if (selectedPaymentType == 'Receive' && selectedProjectStage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select project stage for Receive payment type')),
      );
      return;
    }

    // Step 3️⃣: Bank validation (if payment method is Bank)
    if (selectedPaymentMethod == 'Bank' && selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bank for bank payment')),
      );
      return;
    }

    // Step 4️⃣: Field validation
    if (_amountController.text.isEmpty ||
        _paymentByController.text.isEmpty ||
        _receivedByController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Step 5️⃣: Validate amount
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Step 6️⃣: Get provider instance
    final bankingProvider = context.read<BankingPaymentsProvider>();

    // Step 7️⃣: Extract project and client IDs safely
    final projectRefId = selectedProjectData?['project_ref_id']?.toString() ?? selectedProject!;
    final clientRefId = selectedProjectData?['client_id']?['client_ref_id']?.toString() ?? '';

    // Step 8️⃣: Determine payment type (Receive = in, Expense = out)
    final paymentTypeValue = selectedPaymentType == 'Receive' ? 'in' : 'out';

    // Step 9️⃣: Parse optional values
    final stepCostVal = (selectedPaymentType == 'Expense' && _stepCostController.text.isNotEmpty)
        ? double.tryParse(_stepCostController.text)
        : null;

    final additionalProfitVal = (selectedPaymentType == 'Expense' && _additionalCostController.text.isNotEmpty)
        ? double.tryParse(_additionalCostController.text)
        : null;

    // Step 🔟: Prepare file for upload (if any attached documents exist)
    dynamic fileToUpload;
    if (attachedFiles.isNotEmpty) {
      // Use the first attached file for upload
      final firstAttachedFile = attachedFiles.first;
      print('🔍 Debug: Found ${attachedFiles.length} attached files');
      print('🔍 Debug: First attached file: ${firstAttachedFile}');
      
      fileToUpload = firstAttachedFile['file'];
      print('🔍 Debug: File to upload type: ${fileToUpload.runtimeType}');
      
      if (fileToUpload is PlatformFile) {
        print('🔍 Debug: PlatformFile name: ${fileToUpload.name}');
        print('🔍 Debug: PlatformFile bytes: ${fileToUpload.bytes?.length ?? 'null'}');
      } else if (fileToUpload is File) {
        print('🔍 Debug: File path: ${fileToUpload.path}');
      }
    } else {
      print('🔍 Debug: No attached files found');
    }

    // Step 🔟: Call provider method with file upload
    String fileInfo = 'null';
    if (fileToUpload != null) {
      if (fileToUpload is PlatformFile) {
        fileInfo = 'PlatformFile: ${fileToUpload.name}';
      } else if (fileToUpload is File) {
        fileInfo = 'File: ${fileToUpload.path}';
      } else {
        fileInfo = 'Unknown: ${fileToUpload.runtimeType}';
      }
    }
    print('🔍 Debug: Calling addBankingPayment with file: $fileInfo');
    await bankingProvider.addBankingPayment(
      type: 'project',
      typeRef: projectRefId,
      clientRef: clientRefId,
      paymentType: paymentTypeValue,
      payBy: _paymentByController.text,
      receivedBy: _receivedByController.text,
      totalAmount: amount,
      paidAmount: amount,
      status: 'completed',
      paymentMethod: selectedPaymentMethod!.toLowerCase(),
      transactionId:
      _serviceTIDController.text.isNotEmpty ? _serviceTIDController.text : null,
      bankRefId: selectedBank,
      chequeNo: selectedPaymentMethod == 'Cheque' && _serviceTIDController.text.isNotEmpty
          ? _serviceTIDController.text
          : null,
      stepCost: stepCostVal,
      additionalProfit: additionalProfitVal,
      projectStageRefId: selectedStageData?['project_stage_ref_id']?.toString(),
      file1: fileToUpload, // Upload the attached file
    );

    // Step 1️⃣1️⃣: Handle provider result
    if (bankingProvider.successMessage != null &&
        bankingProvider.successMessage!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bankingProvider.successMessage!)),
      );
      _clearForm();
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    } else if (bankingProvider.errorMessage != null &&
        bankingProvider.errorMessage!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bankingProvider.errorMessage!)),
      );
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
    print('🔍 Debug: File picker started');
    
    // Clear any existing file selection first
    setState(() {
      selectedFile = null;
      selectedFileName = null;
      selectedFileBytes = null;
    });
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'tif'],
        allowMultiple: false, // Ensure only one file can be selected
        withData: true,
        withReadStream: false,
        allowCompression: true,
      );

      print('🔍 Debug: File picker result: ${result != null ? 'Success' : 'Cancelled'}');

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        print('🔍 Debug: Selected file: ${file.name}');
        print('🔍 Debug: File path: ${file.path}');
        print('🔍 Debug: File size: ${file.size}');
        print('🔍 Debug: File bytes: ${file.bytes?.length ?? 'null'}');

        setState(() {
          if (kIsWeb) {
            selectedFile = file;
            selectedFileBytes = file.bytes;
            selectedFileName = file.name;
            print('🔍 Debug: Web mode - file stored as PlatformFile');
          } else {
            if (file.path != null && file.path!.isNotEmpty) {
              selectedFile = File(file.path!);
              selectedFileName = file.name;
              print('🔍 Debug: Mobile mode - file stored as File: ${file.path}');
            } else {
              print('🔍 Debug: Mobile mode - file path is null or empty');
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
      } else {
        print('🔍 Debug: No file selected or result is empty');
      }
    } catch (e) {
      print('🔍 Debug: File picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _attachDocument() async {
    if (_isProcessing) return;

    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a file first')));
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Create a mock document ID for attachment (not uploaded to server)
      final mockDocumentId = 'attached_${DateTime.now().millisecondsSinceEpoch}';
      
      // Create document data for local storage
      final documentData = {
        'document_ref_id': mockDocumentId,
        'name': selectedFileName ?? 'Document',
        'issue_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'expire_date': DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 365))),
        'file_name': selectedFileName,
        'file_size': _getFileSize(),
        'file_type': _getFileTypeDescription(),
        'is_attached': true, // Mark as attached but not uploaded
        'attached_at': DateTime.now().toIso8601String(),
      };

        if (mounted) {
        // Store file name before clearing
        final fileName = selectedFileName ?? 'Document';
        
          setState(() {
          // Add to transaction documents list
          transactionDocuments.add(documentData);
          
          // Store file reference for upload
          if (selectedFile != null) {
            print('🔍 Debug: Storing file for upload');
            print('🔍 Debug: File type: ${selectedFile.runtimeType}');
            print('🔍 Debug: File name: $selectedFileName');
            
            attachedFiles.add({
              'document_ref_id': mockDocumentId,
              'file': selectedFile,
              'file_name': selectedFileName,
              'file_bytes': selectedFileBytes,
            });
            
            print('🔍 Debug: Total attached files: ${attachedFiles.length}');
          } else {
            print('🔍 Debug: No file to store (selectedFile is null)');
          }
          
          // Clear selected file
            selectedFile = null;
            selectedFileName = null;
            selectedFileBytes = null;
        });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
            content: Text('Document attached successfully: $fileName'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            ),
          );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to attach document: ${e.toString()}'),
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

  void _previewDocument() {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No document selected')));
      return;
    }

    // Show document preview dialog
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Document Preview',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description, color: Colors.blue, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedFileName ?? 'Unknown File',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  'File Size: ${_getFileSize()}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getFileIcon(),
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getFileTypeDescription(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Preview not available for this file type',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _removeSelectedFile() {
    setState(() {
      selectedFile = null;
      selectedFileName = null;
      selectedFileBytes = null;
      // Also clear any attached files to reset the button state
      attachedFiles.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File removed'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _getFileSize() {
    if (selectedFile == null) return 'Unknown';
    
    if (kIsWeb && selectedFileBytes != null) {
      final bytes = selectedFileBytes!.length;
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (selectedFile is File) {
      final file = selectedFile as File;
      try {
        final bytes = file.lengthSync();
        if (bytes < 1024) return '$bytes B';
        if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      } catch (e) {
        return 'Unknown';
      }
    }
    return 'Unknown';
  }

  IconData _getFileIcon() {
    if (selectedFileName == null) return Icons.description;
    
    final extension = selectedFileName!.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'tiff':
      case 'tif':
        return Icons.image;
      default:
        return Icons.description;
    }
  }

  String _getFileTypeDescription() {
    if (selectedFileName == null) return 'Unknown File Type';
    
    final extension = selectedFileName!.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'PDF Document';
      case 'doc':
      case 'docx':
        return 'Word Document';
      case 'txt':
        return 'Text File';
      case 'jpg':
      case 'jpeg':
        return 'JPEG Image';
      case 'png':
        return 'PNG Image';
      case 'gif':
        return 'GIF Image';
      case 'bmp':
        return 'Bitmap Image';
      case 'tiff':
      case 'tif':
        return 'TIFF Image';
      default:
        return 'Document File';
    }
  }

  Widget _buildDocumentItem({
    required String name,
    required String issueDate,
    required String expiryDate,
    required String documentRefId,
    required bool isExisting,
    String? url,
  }) {
    // Check if this is an attached document (not uploaded)
    final isAttached = documentRefId.startsWith('attached_');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAttached ? Colors.orange.shade50 : Colors.grey.shade50,
        border: Border.all(
          color: isAttached ? Colors.orange.shade300 : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            isAttached ? Icons.attach_file : Icons.description, 
            color: isAttached ? Colors.orange : Colors.blue, 
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (isAttached)
                  Text(
                    'Attached (Not Uploaded)',
                    style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
                  )
                else if (issueDate.isNotEmpty || expiryDate.isNotEmpty)
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
              if (!isAttached) // Only show download for uploaded documents
              IconButton(
                onPressed: () => _downloadDocument(documentRefId, url: url),
                icon: const Icon(Icons.download, color: Colors.blue, size: 20),
                tooltip: 'Download Document',
              ),
              IconButton(
                onPressed: () => _deleteDocument(documentRefId),
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                tooltip: 'Remove Document',
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
    // Check if this is an attached document (not uploaded)
    final isAttached = documentRefId.startsWith('attached_');
    
    if (isAttached) {
      // For attached documents, just remove from local list
      setState(() {
        transactionDocuments.removeWhere((doc) => doc['document_ref_id'] == documentRefId);
        attachedFiles.removeWhere((file) => file['document_ref_id'] == documentRefId);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attached document removed')),
      );
    } else {
      // For uploaded documents, call the provider to delete from server
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


}

void showBankTransactionDialog(BuildContext context) {
  showDialog(context: context, barrierDismissible: false, builder: (context) => const DialogueBankTransaction());
}

