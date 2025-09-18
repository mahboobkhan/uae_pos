import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/projects_provider.dart';
import '../../../providers/service_category_provider.dart';
import '../../../providers/client_profile_provider.dart';
import '../../../providers/client_organization_employee_provider.dart';

import '../../dialogs/calender.dart';
import '../../dialogs/custom_fields.dart';

class CreateOrderDialog extends StatefulWidget {
  const CreateOrderDialog({super.key});

  @override
  State<CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<CreateOrderDialog> {
  String? selectedOrderType;
  String? searchClient;
  String? selectedServiceProject;
  String? selectedEmployee = "Self";

  String? _beneficiaryController;
  DateTime selectedDateTime = DateTime.now();

  final _fundsController = TextEditingController(text: "");
  final _quotationController = TextEditingController(text: "");
  final _clientSelf = TextEditingController(text: "Self");
  final _pendingPaymentController = TextEditingController(text: "");
  final _tagsController = TextEditingController(text: "");
  String employeeName = 'Loading...';
  Map<String, dynamic>? _selectedClient;

  bool _isOrg(Map<String, dynamic>? c) {
    final t = (c?['client_type'] ?? '').toString().toLowerCase();
    return t == 'organization' || t == 'company' || t == 'corporate';
  }

  // Form validation
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load service categories when dialog initializes
    loadName().then((name) {
      setState(() {
        employeeName = name;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<ServiceCategoryProvider>();
        provider.getServiceCategories();
        final cp = context.read<ClientProfileProvider>();
        if (cp.clients.isEmpty && !cp.isLoading) cp.getAllClients();
      }
    });
  }

  void _loadEmployeesForClient(String? clientRefId) {
    if (clientRefId != null && _selectedClient != null && _isOrg(_selectedClient)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final employeeProvider = context.read<ClientOrganizationEmployeeProvider>();
          employeeProvider.getAllEmployees(clientRefId: clientRefId);
        }
      });
    }
  }

  @override
  void dispose() {
    _fundsController.dispose();
    _quotationController.dispose();
    _pendingPaymentController.dispose();
    _tagsController.dispose();
    super.dispose();
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
    final service = provider.serviceCategories.firstWhere((service) => service['service_name'] == serviceName, orElse: () => {});
    return service['quotation']?.toString();
  }

  String? _getCategoryForService(String? serviceName) {
    if (serviceName == null) return null;
    final provider = context.read<ServiceCategoryProvider>();
    final service = provider.serviceCategories.firstWhere((service) => service['service_name'] == serviceName, orElse: () => {});
    return service['ref_id']?.toString();
  }

  // Get service provider for selected service
  String? _getServiceProviderForService(String? serviceName) {
    if (serviceName == null) return null;
    final provider = context.read<ServiceCategoryProvider>();
    final service = provider.serviceCategories.firstWhere((service) => service['service_name'] == serviceName, orElse: () => {});
    return service['service_provider_name']?.toString();
  }

  void _selectDateTime() {
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
                setState(() {
                  selectedDateTime = selectedDate;
                });
                Navigator.pop(context); // close dialog
              },
              child: const Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitProject() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final provider = context.read<ProjectsProvider>();
      final sharePref = await SharedPreferences.getInstance();

      await provider.addProject(
        clientId:
            (_selectedClient?['client_ref_id'] ?? _selectedClient?['client_id'] ?? searchClient) // falls back to name
                ?.toString(),
        orderType: selectedOrderType,
        serviceCategoryId: _getCategoryForService(selectedServiceProject),
        userId: sharePref.getString('user_id'),
        status: 'Draft',
        // Default status for new projects
        stageId: '',
        // Default stage ID
        quotation: _quotationController.text.isNotEmpty ? _quotationController.text : null,
        pendingPayment: _pendingPaymentController.text.isNotEmpty ? _pendingPaymentController.text : null,
        tags: _tagsController.text.isNotEmpty ? _tagsController.text : null,
      );

      if (provider.errorMessage == null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(provider.successMessage ?? 'Project created successfully'), backgroundColor: Colors.green));
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Create New Order", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red))],
                    ),
                    IconButton(
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
                          Navigator.of(context).pop(); // close the dialog
                        }
                      },
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
                        IconButton(icon: Icon(Icons.close, color: Colors.red), onPressed: () => setState(() => _errorMessage = null)),
                      ],
                    ),
                  ),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    // _buildDateTimeField(),
                    Consumer<ClientProfileProvider>(
                      builder: (context, clientProv, _) {
                        final clients = clientProv.clients;
                        final clientNames = clients.map((c) => (c['name'] ?? 'Unnamed').toString()).toList();

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // your original dropdown, now fed by provider
                            CustomDropdownWithSearch(
                              label: "Search Client ",
                              selectedValue: searchClient,
                              options: clientNames,
                              onChanged: (val) {
                                setState(() {
                                  searchClient = val;
                                  _selectedClient = clients.firstWhere((c) => (c['name'] ?? '').toString() == (val ?? ''), orElse: () => {});
                                  // reset employee on client change
                                  selectedEmployee = null;
                                });

                                // Load employees if organization is selected
                                if (_selectedClient != null && _isOrg(_selectedClient)) {
                                  final clientRefId = _selectedClient!['client_ref_id']?.toString();
                                  _loadEmployeesForClient(clientRefId);
                                }
                              },
                            ),

                            // individual -> show Self (InfoBox)
                            if (_selectedClient != null) const SizedBox(width: 10),

                            // individual -> show Self (InfoBox)
                            if (_selectedClient != null && !_isOrg(_selectedClient))
                              CustomTextField(label: "Client", controller: _clientSelf, hintText: 'Self', keyboardType: TextInputType.text)
                            // organization -> show employee dropdown (dynamic list)
                            else if (_selectedClient != null && _isOrg(_selectedClient))
                              _buildEmployeeDropdown(),
                          ],
                        );
                      },
                    ),
                    CustomDropdownField(
                      label: "Order Type ",
                      selectedValue: selectedOrderType,
                      options: ["Services Base", " Project base"],
                      onChanged: (val) {
                        setState(() => selectedOrderType = val);
                      },
                    ),
                    Consumer<ServiceCategoryProvider>(
                      builder: (context, serviceProvider, child) {
                        return CustomDropdownWithSearch(
                          label: "Service Project ",
                          selectedValue: selectedServiceProject,
                          options: serviceProvider.serviceCategories.map((service) => service['service_name'].toString() ?? '').toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedServiceProject = val;
                              // Auto-fill quotation and service provider when service is selected
                              if (val != null) {
                                final quotation = _getQuotationForService(val);
                                final serviceProvider = _getServiceProviderForService(val);
                                if (quotation != null) {
                                  _quotationController.text = quotation;
                                }
                                if (serviceProvider != null) {
                                  _beneficiaryController = serviceProvider;
                                }
                              }
                            });
                          },
                        );
                      },
                    ),
                    Consumer<ServiceCategoryProvider>(
                      builder: (context, serviceProvider, child) {
                        return CustomDropdownWithSearch(
                          label: "Service Provider",
                          options: serviceProvider.serviceCategories.map((service) => service['service_provider_name'].toString() ?? '').toList(),
                          selectedValue: _beneficiaryController,
                          onChanged: (val) {
                            setState(() => _beneficiaryController = val);
                          },
                        );
                      },
                    ),
                    CustomTextField(
                      label: "Order Quote Price",
                      controller: _quotationController,
                      hintText: '500',
                      keyboardType: TextInputType.number,
                    ),
                    InfoBox(
                      label: employeeName,
                      value: 'Assign Employee',
                      color: Colors.blue.shade200, // light blue fill
                    ),
                    /*InfoBox(
                      label: '500',
                      value: 'Received Funds',
                      color: Colors.blue.shade200, // light blue fill
                    ),
                    InfoBox(
                      label: 'xxxxxxxx',
                      value: 'Transaction Id',
                      color: Colors.yellow.shade100, // light blue fill
                    ),*/
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Row(
                    children: [
                      CustomButton(
                        text: "Save Draft",
                        backgroundColor: Colors.blue,
                        onPressed:
                            _isSubmitting
                                ? () {}
                                : () {
                                  // Save as draft logic
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text('Draft saved successfully'), backgroundColor: Colors.blue));
                                },
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        text: _isSubmitting ? "Creating..." : "Submit",
                        backgroundColor: Colors.green,
                        onPressed: _isSubmitting ? () {} : _submitProject,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> loadName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'N/A'; // fallback if not set
  }

  Widget _buildDateTimeField() {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: () {
          // _selectDateTime();
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: "Date and Time ",
            labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_month_outlined, color: Colors.red, size: 22),
          ),
          child: Text(DateFormat("dd-MM-yyyy - hh:mm a").format(selectedDateTime), style: const TextStyle(fontSize: 14)),
        ),
      ),
    );
  }

  /// Build employee dropdown for organization clients
  Widget _buildEmployeeDropdown() {
    return Consumer<ClientOrganizationEmployeeProvider>(
      builder: (context, employeeProvider, child) {
        if (employeeProvider.isLoading) {
          return SizedBox(
            width: 220,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade100, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
              child: Row(
                children: [
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 8),
                  Text('Loading employees...', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }

        if (employeeProvider.errorMessage != null) {
          return SizedBox(
            width: 220,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Error loading employees', style: TextStyle(color: Colors.red, fontSize: 12)),
                  Text(employeeProvider.errorMessage!, style: TextStyle(color: Colors.red, fontSize: 10)),
                ],
              ),
            ),
          );
        }

        if (employeeProvider.employees.isEmpty) {
          return SizedBox(
            width: 220,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('No employees found', style: TextStyle(color: Colors.orange, fontSize: 12)),
            ),
          );
        }

        // Create dropdown options from employees
        final employeeOptions =
            employeeProvider.employees.map((employee) {
              final name = employee['name'] ?? 'Unknown';
              final type = employee['type'] ?? '';
              final email = employee['email'] ?? '';
              return '$name ($type) - $email';
            }).toList();

        return CustomDropdownWithSearch(
          label: "Self",
          selectedValue: selectedEmployee,
          options: employeeOptions,
          onChanged: (val) {
            setState(() => selectedEmployee = val);
          },
        );
      },
    );
  }
}
