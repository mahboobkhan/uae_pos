import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/projects_provider.dart';
import '../../../providers/service_category_provider.dart';
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
  String? selectedEmployee;
  String? _beneficiaryController;
  DateTime selectedDateTime = DateTime.now();

  final _fundsController = TextEditingController(text: "");
  final _quotationController = TextEditingController(text: "");
  final _pendingPaymentController = TextEditingController(text: "");
  final _tagsController = TextEditingController(text: "");
  String employeeName = 'Loading...';


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
      }
    });
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
        clientId: searchClient,
        orderType: selectedOrderType,
        serviceCategoryId: selectedServiceProject,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Create New Order", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
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
                  decoration: BoxDecoration(color: Colors.red.shade50, border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(4)),
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
                  _buildDateTimeField(),
                  CustomDropdownWithSearch(
                    label: "Search Client ",
                    selectedValue: searchClient,
                    options: ["Ali", "Ahmed", "Zara", "Ayesha", "Hassan", "Sana", "Usman", "Bilal", "Imran", "Salman", "Noor", "Khalid"],
                    onChanged: (val) {
                      setState(() => searchClient = val);
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
                  InfoBox(
                    label: '500',
                    value: 'Received Funds',
                    color: Colors.blue.shade200, // light blue fill
                  ),
                  InfoBox(
                    label: 'xxxxxxxx',
                    value: 'Transaction Id',
                    color: Colors.yellow.shade100, // light blue fill
                  ),
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

  /*
  Widget _buildDropdown(
      String? label,
      String? selectedValue,
      List<String> options,
      ValueChanged<String?> onChanged,
      ) {
    return SizedBox(
      width: 220,
      height: 48, // Similar to the default form field height
      child: CustomDropdown<String>(
        hintText: label ?? '',
        items: options,
        initialItem: selectedValue,
        decoration: CustomDropdownDecoration(
          closedBorder: Border.all(color: Colors.grey),
          closedBorderRadius: BorderRadius.circular(4),
          expandedBorder: Border.all(color: Colors.red, width: 1),
          expandedBorderRadius: BorderRadius.circular(4),
          closedFillColor: Colors.white,
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          listItemStyle: const TextStyle(fontSize: 16, color: Colors.black),
          closedPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          expandedPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        ),
        onChanged: onChanged,
      ),
    );
  }
*/
}
