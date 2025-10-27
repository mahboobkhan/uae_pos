import 'dart:js_interop';

import 'package:abc_consultant/employee/EmployeeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../employee/employee_models.dart';
import '../../providers/short_services_provider.dart';
import '../../providers/short_service_category_provider.dart';
import 'custom_fields.dart';



void showShortServicesPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String serviceName = '';
      String? selectedInstitute;
      String cost = '';

      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actionsAlignment: MainAxisAlignment.start,

        content: SizedBox(
          width: 340,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ADD SERVICES",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "Tid 000000000234",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    CustomTextField1(
                      label: 'SERVICE NAME',
                      onChanged: (val) => serviceName = val,
                    ),
                    const SizedBox(height: 12),

                    // CustomDropdownWithRightAdd(
                    //   label: ' SERVICES',
                    //   value: selectedInstitute,
                    //   items: instituteOptions,
                    //   onChanged: (val) => selectedInstitute = val,
                    //   onAddPressed: () {
                    //     showInstituteManagementDialog(context);
                    //   },
                    // ),
                    const SizedBox(height: 12),

                    CustomTextField1(
                      label: 'COST ',
                      keyboardType: TextInputType.number,
                      onChanged: (val) => cost = val,
                    ),

                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Create',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Cross icon top right
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 25, color: Colors.red),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<String> getUserName() async {

  final sharePref = await SharedPreferences.getInstance();

  return sharePref.getString('name')??"";

}

// Services Project - Support for multiple services
void showServicesProjectPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // List to hold multiple services
      List<Map<String, dynamic>> services = [];

      // Current service being edited
      String clientName = '';
      String? selectedServiceCategory;
      String quantity = '1';
      String unitPrice = '';
      String discount = '0';
      String managerName = '';
      String? selectedPaymentMethod;
      String? selectedPaymentStatus;
      String transactionId = '';
      String bankRefId = '';
      String chequeNo = '';

      final List<String> paymentMethods = ['Select Payment Method','cash', 'bank', 'cheque'];
      final List<String> paymentStatuses = ['Select Payment Status','pending', 'completed'];

      return Consumer<ShortServiceCategoryProvider>(
        builder: (context, categoryProvider, child) {
          // Load categories when dialog opens
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (categoryProvider.categories.isEmpty && !categoryProvider.isLoading) {
              categoryProvider.getAllShortServiceCategories();
            }
          });

          // Get category names for dropdown
          final List<String> serviceOptions = categoryProvider.categories
              .map((category) => category['category_name'] as String)
              .toList();

          return StatefulBuilder(
            builder: (context, setState) {
              // Helper to add service to list
              void addServiceToList() {
                if (clientName.isNotEmpty &&
                    selectedServiceCategory != null &&
                    unitPrice.isNotEmpty &&
                    managerName.isNotEmpty) {

                  Map<String, dynamic> service = {
                    "service_category_name": selectedServiceCategory,
                    "quantity": int.tryParse(quantity) ?? 1,
                    "unit_price": double.tryParse(unitPrice) ?? 0.0,
                    "discount": double.tryParse(discount) ?? 0.0,
                  };

                  // Add optional payment fields
                  if (selectedPaymentMethod != null) service["payment_method"] = selectedPaymentMethod;
                  if (selectedPaymentStatus != null) service["payment_status"] = selectedPaymentStatus;
                  if (transactionId.isNotEmpty) service["transaction_id"] = transactionId;
                  if (bankRefId.isNotEmpty) service["bank_ref_id"] = bankRefId;
                  if (chequeNo.isNotEmpty) service["cheque_no"] = chequeNo;

                  setState(() {
                    services.add(service);
                    // Clear only service-specific fields (keep client name and manager name fixed)
                    selectedServiceCategory = null;
                    quantity = '1';
                    unitPrice = ''; // Will be auto-filled when next category is selected
                    discount = '0';
                    // Don't clear payment fields as they apply to all services
                    // Don't clear clientName and managerName as they are fixed for all services
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Service added to list'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all required fields'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              }

              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                content: SizedBox(
                  width: 800,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Add Short Service(s)",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // First Row: Client Name and Assign Employee (Fixed after first service)
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField1(
                                      label: 'Client Name *',
                                      text: clientName,
                                      enabled: services.isEmpty, // Disable after first service
                                      onChanged: (val) => clientName = val,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: FutureBuilder<String>(
                                      future: getUserName(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else {
                                          if (managerName.isEmpty && snapshot.data != null) {
                                            managerName = snapshot.data!;
                                          }
                                          return CustomTextField1(
                                            enabled: false, // Always disabled
                                            label: 'Assign Employee *',
                                            text: managerName,
                                            onChanged: (val) => managerName = val,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Second Row: Service Category, Quantity, Unit Price, Discount, Add Button
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomDropdownWithRightAdd(
                                      label: 'Service Category *',
                                      value: selectedServiceCategory,
                                      items: serviceOptions,
                                      onChanged: (val) {
                                        setState(() {
                                          selectedServiceCategory = val;
                                          // Auto-fill unit price when category is selected
                                          if (val != null) {
                                            final selectedCategory = categoryProvider.categories.firstWhere(
                                              (category) => category['category_name'] == val,
                                              orElse: () => {},
                                            );
                                            print('selectedCategies $selectedCategory');
                                            if (selectedCategory.isNotEmpty) {
                                              unitPrice = selectedCategory['quotation']?.toString() ?? '0';
                                            }
                                          }
                                        });
                                      },
                                      onAddPressed: () {
                                        showServiceCategoryManagementDialog(context);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: CustomTextField1(
                                      label: 'Quantity *',
                                      text: quantity,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => quantity = val,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: CustomTextField1(
                                      label: 'Unit Price *',
                                      text: unitPrice,
                                      keyboardType: TextInputType.number,
                                      enabled: false, // Make non-editable - auto-filled from category
                                      onChanged: (val) => unitPrice = val,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: CustomTextField1(
                                      label: 'Discount',
                                      text: discount,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => discount = val,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.add, color: Colors.white, size: 16),
                                      label: const Text('Add Service', style: TextStyle(color: Colors.white, fontSize: 12)),
                                      onPressed: addServiceToList,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Services List
                              if (services.isNotEmpty) ...[
                                const Text(
                                  "Added Services:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    children: [
                                      ...services.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final service = entry.value;
                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 8),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${index + 1}. ",
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            service['service_category_name'] ?? 'N/A',
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Qty: ${service['quantity'] ?? 1} × AED ${service['unit_price'] ?? 0}",
                                                            style: const TextStyle(
                                                              fontSize: 11,
                                                              color: Colors.black87,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Total: AED ${((service['quantity'] ?? 1) * (service['unit_price'] ?? 0) - (service['discount'] ?? 0)).toStringAsFixed(2)}",
                                                          style: const TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if ((service['discount'] ?? 0) > 0) ...[
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        "Discount: AED ${service['discount']?.toString() ?? '0'}",
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                onPressed: () {
                                                  setState(() {
                                                    services.removeAt(index);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              const Text(
                                "Payment Details (Optional)",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              // Payment Method
                              CustomDropdownField(
                                label: 'Payment Method',
                                selectedValue: selectedPaymentMethod,
                                options: paymentMethods,
                                onChanged: (val) => setState(() => selectedPaymentMethod = val== 'Select Payment Method'? null: val),
                                width: double.infinity,
                              ),
                              const SizedBox(height: 12),
                              // Payment Status
                              CustomDropdownField(
                                label: 'Payment Status',
                                selectedValue: selectedPaymentStatus,
                                options: paymentStatuses,
                                onChanged: (val) => setState(() => selectedPaymentStatus = val=='Select Payment Status'? null: val),
                                width: double.infinity,
                              ),
                              const SizedBox(height: 12),

                              // Show conditional fields based on payment method
                              if (selectedPaymentMethod == 'bank') ...[
                                CustomTextField1(
                                  label: 'Transaction ID',
                                  text: transactionId,
                                  onChanged: (val) => transactionId = val,
                                ),
                                const SizedBox(height: 12),
                                CustomTextField1(
                                  label: 'Bank Ref ID',
                                  text: bankRefId,
                                  onChanged: (val) => bankRefId = val,
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (selectedPaymentMethod == 'cheque') ...[
                                CustomTextField1(
                                  label: 'Cheque No',
                                  text: chequeNo,
                                  onChanged: (val) => chequeNo = val,
                                ),
                                const SizedBox(height: 12),
                              ],

                              const SizedBox(height: 20),

                              // Submit buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: () async {
                                      // Add current service if filled
                                      if (clientName.isNotEmpty &&
                                          selectedServiceCategory != null &&
                                          unitPrice.isNotEmpty &&
                                          managerName.isNotEmpty) {
                                        addServiceToList();
                                      }

                                      // Submit all services
                                      if (services.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Please add at least one service'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      try {
                                        // Get user_ref_id from SharedPreferences
                                        final prefs = await SharedPreferences.getInstance();
                                        final userRefId = prefs.getString('user_id') ?? '';

                                        if (userRefId.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('User not logged in'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }

                                        final provider = context.read<ShortServicesProvider>();
                                        await provider.addMultipleShortServices(
                                          userRefId: userRefId,
                                          clientName: clientName,
                                          managerName: managerName,
                                          services: services,
                                          paymentMethod: selectedPaymentMethod,
                                          paymentStatus: selectedPaymentStatus,
                                          transactionId: transactionId.isNotEmpty ? transactionId : null,
                                          bankRefId: bankRefId.isNotEmpty ? bankRefId : null,
                                          chequeNo: chequeNo.isNotEmpty ? chequeNo : null,
                                        );

                                        if (provider.errorMessage == null) {
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(provider.successMessage ?? '${services.length} service(s) added successfully'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(provider.errorMessage!),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Close Icon
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 25, color: Colors.red),
                          onPressed: () => Navigator.of(context).pop(),
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
    },
  );
}

// Service Category Management Dialog
void showServiceCategoryManagementDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Consumer<ShortServiceCategoryProvider>(
        builder: (context, categoryProvider, child) {
          // Load categories when dialog opens
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (categoryProvider.categories.isEmpty && !categoryProvider.isLoading) {
              categoryProvider.getAllShortServiceCategories();
            }
          });

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.all(12),
                insetPadding: const EdgeInsets.all(20),
                content: SizedBox(
                  width: 400,
                  height: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Service Categories',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 25, color: Colors.red),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Add category form
                      _buildAddCategoryForm(context, categoryProvider, setState),
                      const SizedBox(height: 12),

                      // Categories list
                      Expanded(
                        child: _buildCategoriesList(context, categoryProvider, setState),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}

Widget _buildAddCategoryForm(BuildContext context, ShortServiceCategoryProvider categoryProvider, StateSetter setState) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quotationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: quotationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quotation',
                  labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            isDense: true,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: categoryProvider.isLoading ? null : () async {
              if (nameController.text.trim().isNotEmpty && quotationController.text.trim().isNotEmpty) {
                // Get user_ref_id from SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                final userRefId = prefs.getString('ref_id') ?? '';

                if (userRefId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User not logged in'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                await categoryProvider.addShortServiceCategory(
                  userRefId: userRefId,
                  categoryName: nameController.text.trim(),
                  quotation: quotationController.text.trim(),
                  description: descriptionController.text.trim(),
                );

                if (categoryProvider.errorMessage == null) {
                  nameController.clear();
                  quotationController.clear();
                  descriptionController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(categoryProvider.successMessage ?? 'Category added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(categoryProvider.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill category name and quotation'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: categoryProvider.isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Add Category', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCategoriesList(BuildContext context, ShortServiceCategoryProvider categoryProvider, StateSetter setState) {
  if (categoryProvider.isLoading) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading categories...'),
        ],
      ),
    );
  }

  if (categoryProvider.errorMessage != null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            categoryProvider.errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => categoryProvider.getAllShortServiceCategories(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  if (categoryProvider.categories.isEmpty) {
    return const Center(
      child: Text(
        'No categories available',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }

  return ListView.builder(
    itemCount: categoryProvider.categories.length,
    itemBuilder: (context, index) {
      final category = categoryProvider.categories[index];
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          title: Text(
            category['category_name'] ?? 'N/A',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          /*subtitle: Text(
            category['description'] ?? 'No description',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),*/
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (category['status'] == 'active') ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              category['status'] ?? 'unknown',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    },
  );
}


void showInstituteManagementDialog(BuildContext context) {
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
              borderRadius: BorderRadius.circular(
                12,
              ), // Slightly smaller radius
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
                        icon: const Icon(
                          Icons.close,
                          size: 25,
                          color: Colors.red,
                        ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {
                            if (addController.text.trim().isNotEmpty) {
                              setState(() {
                                institutes.add(addController.text.trim());
                                addController.clear();
                              });
                            }
                          },
                          child: const Text(
                            "Add",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Compact list
                  Expanded(
                    child:
                        institutes.isEmpty
                            ? const Center(
                              child: Text(
                                'No institutes',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    title: Text(
                                      institutes[index],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    trailing: SizedBox(
                                      width:
                                          80, // Constrained width for buttons
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 18,
                                              color: Colors.green,
                                            ),
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
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Colors.red,
                                            ),
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.grey),
                  ),
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
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
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

void showInstituteManagementDialog1(BuildContext context) {
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
              borderRadius: BorderRadius.circular(
                12,
              ), // Slightly smaller radius
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
                        icon: const Icon(
                          Icons.close,
                          size: 25,
                          color: Colors.red,
                        ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {
                            if (addController.text.trim().isNotEmpty) {
                              setState(() {
                                institutes.add(addController.text.trim());
                                addController.clear();
                              });
                            }
                          },
                          child: const Text(
                            "Add",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Compact list
                  Expanded(
                    child:
                        institutes.isEmpty
                            ? const Center(
                              child: Text(
                                'No institutes',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    title: Text(
                                      institutes[index],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    trailing: SizedBox(
                                      width:
                                          80, // Constrained width for buttons
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 18,
                                              color: Colors.green,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed:
                                                () => _showEditDialog1(
                                                  context,
                                                  setState,
                                                  institutes,
                                                  index,
                                                  editController,
                                                ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Colors.red,
                                            ),
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

void _showEditDialog1(
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.grey),
                  ),
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
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
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

// short sevices 2nd dialog

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double borderRadius;
  final double? fontSize;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 6,
    this.fontSize,
    this.icon, // 👈 Accept icon
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child:
          icon == null
              ? Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: fontSize ?? 16),
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: fontSize ?? 16),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize ?? 16,
                    ),
                  ),
                ],
              ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String? selectedValue;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Icon? icon;

  const CustomDropdown({
    Key? key,
    required this.selectedValue,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey _key = GlobalKey();

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: GestureDetector(
        onTap: () async {
          final RenderBox renderBox =
              _key.currentContext!.findRenderObject() as RenderBox;
          final Offset offset = renderBox.localToGlobal(Offset.zero);
          final double width = renderBox.size.width;

          final selected = await showMenu<String>(
            context: context,
            position: RelativeRect.fromLTRB(
              offset.dx,
              offset.dy + renderBox.size.height,
              offset.dx + width,
              offset.dy,
            ),
            items:
                items.map((item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
          );

          if (selected != null) {
            onChanged(selected);
          }
        },
        child: Container(
          key: _key,
          width: 110,
          height: 25,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  selectedValue ?? hintText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: selectedValue == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              icon ?? const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> showAddTagDialog(BuildContext context) async {
  final TextEditingController _tagController = TextEditingController();
  Color? selectedColor;
  final List<Color> colors = [
    // Green
    Colors.green.shade600,
    Colors.green.shade800,

    Color(0xFFFF0000),

    // Blue
    Colors.blue.shade600,
    Colors.blue.shade800,
    Colors.lightBlue.shade700,

    // Red
    Colors.red.shade600,
    Colors.red.shade800,

    // Purple
    Colors.purple.shade600,
    Colors.purple.shade800,

    // Shocking pink (vibrant pinks)
    Colors.pink.shade600,
    Colors.pinkAccent.shade400,
    Colors.pinkAccent.shade700,

    // Teal
    Colors.teal.shade600,
    Colors.lime.shade800,

    // Orange
    Colors.orange.shade600,
    Colors.orange.shade800,

    // Yellow (darkest available)
    Colors.yellow.shade800,

    // Cyan
    Colors.cyan.shade700,
    Colors.cyan.shade900,
  ];

  return await showDialog<Map<String, dynamic>>(
    context: context,
    builder:
        (_) => StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                titlePadding: EdgeInsets.zero,
                title: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "New Tag",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                content: SizedBox(
                  width: 220,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _tagController,
                        decoration: InputDecoration(
                          labelText: "Tag Name",
                          labelStyle: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ), // 👈 your focused color here
                          ),
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children:
                            colors.map((color) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedColor = color);
                                },
                                child: Container(
                                  width: 41,
                                  height: 41,
                                  decoration: BoxDecoration(
                                    color: color,
                                    border: Border.all(
                                      color:
                                          selectedColor == color
                                              ? Colors.black
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'SAVE',
                        backgroundColor: Colors.blue,
                        borderRadius: 2,
                        onPressed: () {
                          if (_tagController.text.trim().isNotEmpty) {
                            Navigator.of(context).pop({
                              'tag': _tagController.text.trim(),
                              'color': selectedColor ?? colors[0],
                              // Default to first color if none selected
                            });
                          }
                        },
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ),
        ),
  );
}
