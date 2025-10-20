import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/short_services_provider.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';
import '../../../utils/pin_verification_util.dart';

class ShortServiceScreen extends StatefulWidget {
  const ShortServiceScreen({super.key});

  @override
  State<ShortServiceScreen> createState() => _ShortServiceScreenState();
}

class _ShortServiceScreenState extends State<ShortServiceScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  // List of filter options
  final List<String> categories = ['All', 'New', 'Pending', 'Completed', 'Stop'];
  String? selectedCategory;

  final List<String> categories3 = ['All', 'Toady', 'Yesterday', 'Last 7 Days', 'Last 30 Days', 'Custom Range'];
  String? selectedCategory3;
  final GlobalKey _plusKey = GlobalKey();

  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    // Load short services when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Use Future.delayed to ensure the provider is fully initialized
        Future.delayed(Duration(milliseconds: 200), () {
          if (mounted) {
            try {
              final provider = context.read<ShortServicesProvider>();
              print('Provider found: ${provider.runtimeType}');
              provider.getAllShortServices();
            } catch (e) {
              print('Error accessing provider: $e');
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '00-00-0000';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return '00-00-0000';
    }
  }

  String _formatTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '00-00';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '00-00';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use context.watch to automatically rebuild when provider changes
    final shortServicesProvider = context.watch<ShortServicesProvider>();

    // Debug print to see if the provider is working
    print(
      'ShortServiceScreen rebuild - isLoading: ${shortServicesProvider.isLoading}, dataCount: ${shortServicesProvider.shortServices.length}, error: ${shortServicesProvider.errorMessage}',
    );

    // If no data and not loading, try to load data
    if (shortServicesProvider.shortServices.isEmpty &&
        !shortServicesProvider.isLoading &&
        shortServicesProvider.errorMessage == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          print('No data found, attempting to load...');
          shortServicesProvider.getAllShortServices();
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 45,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow:
                      _isHovering
                          ? [BoxShadow(color: Colors.blue, blurRadius: 4, spreadRadius: 0.1, offset: Offset(0, 1))]
                          : [],
                ),
                child: Row(
                  children: [
                    //  Scrollable Row with dropdowns
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            /*CustomDropdown(
                              selectedValue: selectedCategory,
                              hintText: "Status",
                              items: categories,
                              onChanged: (newValue) {
                                setState(() => selectedCategory = newValue!);
                              },
                            ),
                            CustomDropdown(
                              selectedValue: selectedCategory3,
                              hintText: "Dates",
                              items: categories3,
                              onChanged: (newValue) {
                                setState(() => selectedCategory3 = newValue!);
                              },
                              icon: const Icon(Icons.calendar_month, size: 18),
                            ),*/
                          ],
                        ),
                      ),
                    ),

                    // Fixed Right Action Buttons
                    Row(
                      children: [
                        // Refresh Button
                        Card(
                          elevation: 4,
                          color: Colors.green,
                          shape: CircleBorder(),
                          child: Tooltip(
                            message: 'Refresh',
                            waitDuration: Duration(milliseconds: 2),
                            child: GestureDetector(
                              onTap: () => shortServicesProvider.getAllShortServices(),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                child: const Center(child: Icon(Icons.refresh, color: Colors.white, size: 20)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Add Button
                        Card(
                          elevation: 8,
                          color: Colors.blue,
                          shape: CircleBorder(),
                          child: Builder(
                            builder:
                                (context) => Tooltip(
                                  message: 'Add Services',
                                  waitDuration: Duration(milliseconds: 2),
                                  child: GestureDetector(
                                    key: _plusKey,
                                    onTap: () async {
                                      showServicesProjectPopup(context);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(shape: BoxShape.circle),
                                      child: const Center(child: Icon(Icons.add, color: Colors.white, size: 20)),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Show loading indicator
            if (shortServicesProvider.isLoading)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Loading short services...')],
                  ),
                ),
              )
            // Show error message
            else if (shortServicesProvider.errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        shortServicesProvider.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => shortServicesProvider.getAllShortServices(),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            // Show success message
            else if (shortServicesProvider.successMessage != null)
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(child: Text(shortServicesProvider.successMessage!, style: TextStyle(color: Colors.green))),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.green),
                      onPressed: () => shortServicesProvider.clearMessages(),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 15),
            // Show table with data
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbVisibility: MaterialStateProperty.all(true),
                      thumbColor: MaterialStateProperty.all(Colors.grey),
                      thickness: MaterialStateProperty.all(8),
                      radius: const Radius.circular(4),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double tableWidth =
                            constraints.maxWidth < 1150 ? 1150 : constraints.maxWidth; // expand when screen is larger

                        return Scrollbar(
                          controller: _verticalController,
                          thumbVisibility: true,
                          child: Scrollbar(
                            controller: _horizontalController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _horizontalController,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                controller: _verticalController,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: tableWidth),
                                  child: Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FlexColumnWidth(0.2),
                                      1: FlexColumnWidth(0.3),
                                      2: FlexColumnWidth(0.3),
                                      3: FlexColumnWidth(0.3),
                                      4: FlexColumnWidth(0.2),
                                      5: FlexColumnWidth(0.3),
                                      6: FlexColumnWidth(0.4),
                                    },
                                    children: [
                                      // Header Row
                                      TableRow(
                                        decoration: BoxDecoration(color: Colors.red.shade50),
                                        children: [
                                          _buildHeader("Date"),
                                          _buildHeader("Service Beneficiary "),
                                          _buildHeader("Service"),
                                          _buildHeader("Cost"),
                                          _buildHeader("Manager"),
                                          _buildHeader("Ref Id"),
                                          _buildHeader("More Actions"),
                                        ],
                                      ),
                                      // Data Rows
                                      if (shortServicesProvider.shortServices.isNotEmpty)
                                        ...shortServicesProvider.shortServices.asMap().entries.map((entry) {
                                          final index = entry.key;
                                          final service = entry.value;
                                          return TableRow(
                                            decoration: BoxDecoration(
                                              color: index.isEven ? Colors.grey.shade100 : Colors.grey.shade50,
                                            ),
                                            children: [
                                              _buildCell2(
                                                _formatDate(service['updated_at'] ?? service['created_at']),
                                                _formatTime(service['updated_at'] ?? service['created_at']),
                                                centerText2: true,
                                              ),
                                              _buildCell3(
                                                service['client_name'] ?? 'N/A',
                                                service['client_id'] ?? service['ref_id'] ?? 'N/A',
                                                copyable: true,
                                              ),
                                              _buildCell(service['service_category_name'] ?? 'N/A'),
                                              _buildPriceWithAdd(
                                                service['quotation']?.toString() ?? service['pending_payment']?.toString() ?? service['cost']?.toString() ?? '0',
                                              ),
                                              _buildCell(service['manager_name'] ?? 'N/A'),
                                              _buildCell(service['ref_id'] ?? 'N/A', copyable: true),
                                              _buildActionCell(
                                                onEdit: () => _editShortService(context, service),
                                                onDelete: () => _deleteShortService(context, service),
                                              ),
                                            ],
                                          );
                                        }).toList()
                                      else if (!shortServicesProvider.isLoading)
                                        TableRow(
                                          children: List.generate(
                                            7,
                                            (index) => TableCell(
                                              child: Container(
                                                height: 60,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.inbox_outlined, color: Colors.grey.shade400, size: 24),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        'No short services available',
                                                        style: TextStyle(
                                                          color: Colors.grey.shade600,
                                                          fontStyle: FontStyle.italic,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Edit short service
  void _editShortService(BuildContext context, Map<String, dynamic> service) async {
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String clientName = service['client_name'] ?? '';
        String quotation = service['quotation']?.toString() ?? service['cost']?.toString() ?? service['pending_payment']?.toString() ?? '';
        String managerName = service['manager_name'] ?? '';

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: SizedBox(
            width: 400,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Edit Short Service",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "Ref ID: ${service['ref_id'] ?? 'N/A'}",
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField1(label: 'CLIENT NAME', text: clientName, onChanged: (val) => clientName = val),
                      const SizedBox(height: 12),

                      CustomTextField1(
                        label: 'QUOTATION (AED)',
                        keyboardType: TextInputType.number,
                        text: quotation,
                        onChanged: (val) => quotation = val,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField1(label: 'Assign Employee', text: managerName, onChanged: (val) => managerName = val),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            onPressed: () async {
                              // Show PIN verification before updating
                              await PinVerificationUtil.executeWithPinVerification(
                                context,
                                () async {
                                  if (clientName.isNotEmpty && quotation.isNotEmpty && managerName.isNotEmpty) {
                                    try {
                                      final provider = context.read<ShortServicesProvider>();
                                      await provider.updateShortService(
                                        userRefId: userRefId,
                                        refId: service['ref_id'],
                                        clientName: clientName,
                                        quotation: quotation,
                                        managerName: managerName,
                                      );

                                      if (provider.errorMessage == null) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(provider.successMessage ?? 'Service updated successfully'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(provider.errorMessage!), backgroundColor: Colors.red),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please fill all fields'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                },
                                title: "Update Short Service",
                                message: "Please enter your PIN to update this short service",
                              );
                            },
                            child: const Text('Update', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
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
  }

  /// Delete short service
  void _deleteShortService(BuildContext context, Map<String, dynamic> service) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => const ConfirmationDialog(
            title: 'Confirm Deletion',
            content: 'Are you sure you want to delete this short service?',
            cancelText: 'Cancel',
            confirmText: 'Delete',
          ),
    );

    if (shouldDelete == true) {
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

      final provider = context.read<ShortServicesProvider>();
      await provider.deleteShortService(
        userRefId: userRefId,
        refId: service['ref_id'],
      );
    }
  }

  Widget _buildHeader(String text) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCell(String text, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(text, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
          if (copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCell2(String text1, String text2, {bool copyable = false, bool centerText2 = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1, style: const TextStyle(fontSize: 12)),
          centerText2
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                  ),
                  if (copyable)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.copy, size: 14, color: Colors.blue[700]),
                      ),
                    ),
                ],
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54))),
                  if (copyable)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.copy, size: 14, color: Colors.blue[700]),
                      ),
                    ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildCell3(String text1, String text2, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text2, style: const TextStyle(fontSize: 10, color: Colors.black54)),
              if (copyable)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceWithAdd(String price, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SvgPicture.asset('icons/dirham_symble.svg', height: 12, width: 12),
          Text(" $price", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Spacer(),
          if (showPlus)
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.blue)),
              child: const Icon(Icons.add, size: 13, color: Colors.blue),
            ),
        ],
      ),
    );
  }

  Widget _buildActionCell({VoidCallback? onEdit, VoidCallback? onDelete}) {
    return Row(
      children: [
        // IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), tooltip: 'Delete', onPressed: onDelete ?? () {}),
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.green),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
      ],
    );
  }
}
