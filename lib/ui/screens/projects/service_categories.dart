import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/service_category_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/pin_verification_util.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';

class ServiceCategories extends StatefulWidget {
  const ServiceCategories({super.key});

  @override
  State<ServiceCategories> createState() => _ServiceCategoriesState();
}

class _ServiceCategoriesState extends State<ServiceCategories> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  final List<String> categories2 = ['All', 'Pending', 'Paid'];
  String? selectedCategory2;
  bool _isHovering = false;

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ServiceCategoryProvider>(context, listen: false).getServiceCategories());
  }

  void _showAddServiceCategoryDialog(BuildContext context, {Map<String, dynamic>? editData}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String serviceName = editData?['service_name'] ?? '';
        String quotation = editData?['quotation'] ?? '';
        String? serviceProviderName = editData?['service_provider_name'];
        String? refId = editData?['ref_id'];

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
                      Text(
                        editData == null ? "Add Service Category" : "Edit Service Category",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 20),

                      CustomTextField1(
                        label: 'Category Name',
                        text: serviceName,
                        onChanged: (val) => serviceName = val,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField1(
                        label: 'Quotation',
                        text: quotation,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => quotation = val,
                      ),
                      const SizedBox(height: 12),

                      CustomTextField1(
                        label: 'Service Provider',
                        text: serviceProviderName,
                        onChanged: (val) => serviceProviderName = val,
                      ),

                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.redColor,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          onPressed: () async {
                            // Show PIN verification before creating/updating
                            await PinVerificationUtil.executeWithPinVerification(
                              context,
                                  () async {
                                if (editData == null) {
                                  await Provider.of<ServiceCategoryProvider>(context, listen: false).addServiceCategory(
                                    serviceName: serviceName,
                                    quotation: quotation,
                                    serviceProviderName: serviceProviderName,
                                    date: DateTime.now().toIso8601String(),
                                  );
                                } else {
                                  await Provider.of<ServiceCategoryProvider>(context, listen: false).updateServiceCategory(
                                    refId: refId!,
                                    serviceName: serviceName,
                                    quotation: quotation,
                                    serviceProviderName: serviceProviderName,
                                    date: DateTime.now().toIso8601String(),
                                  );
                                }
                                Navigator.of(context).pop();
                              },
                              title: editData == null ? "Create Service Category" : "Update Service Category",
                              message: editData == null
                                  ? "Please enter your PIN to create this service category"
                                  : "Please enter your PIN to update this service category",
                            );
                          },                          child: Text(editData == null ? 'Create' : 'Update', style: TextStyle(color: Colors.white)),
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
                    icon: const Icon(Icons.close, size: 25, color: AppColors.redColor),
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
    final provider = Provider.of<ServiceCategoryProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
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
                                    ? [
                                      const BoxShadow(
                                        color: Colors.blue,
                                        blurRadius: 4,
                                        spreadRadius: 0.1,
                                        offset: Offset(0, 1),
                                      ),
                                    ]
                                    : [],
                          ),
                          child: Row(
                            children: [
                              Spacer(),
                              /*Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      CustomDropdown(
                                        selectedValue: selectedCategory2,
                                        hintText: "Institutes",
                                        items: categories2,
                                        onChanged: (newValue) {
                                          setState(() => selectedCategory2 = newValue!);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),*/
                              Row(
                                children: [
                                  Card(
                                    elevation: 4,
                                    color: Colors.blue,
                                    shape: const CircleBorder(),
                                    child: Builder(
                                      builder:
                                          (context) => Tooltip(
                                            message: 'Add Service Category',
                                            waitDuration: const Duration(milliseconds: 2),
                                            child: GestureDetector(
                                              onTap: () {
                                                _showAddServiceCategoryDialog(context);
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Icon(Icons.add, color: Colors.white, size: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          child: ScrollbarTheme(
                            data: ScrollbarThemeData(
                              thumbVisibility: MaterialStateProperty.all(true),
                              thumbColor: MaterialStateProperty.all(Colors.grey),
                              thickness: MaterialStateProperty.all(8),
                              radius: const Radius.circular(4),
                            ),
                            child: Scrollbar(
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
                                      constraints: const BoxConstraints(minWidth: 1150),
                                      child: Table(
                                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                        columnWidths: const {
                                          0: FlexColumnWidth(1),
                                          1: FlexColumnWidth(1),
                                          2: FlexColumnWidth(1),
                                          3: FlexColumnWidth(1),
                                          4: FlexColumnWidth(1),
                                          5: FlexColumnWidth(1),
                                        },
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(color: Colors.red.shade50),
                                            children: [
                                              _buildHeader("Date"),
                                              _buildHeader("Service Department"),
                                              _buildHeader("Service"),
                                              _buildHeader("Quotation"),
                                              _buildHeader("Ref Id"),
                                              _buildHeader("More Actions"),
                                            ],
                                          ),
                                          if (provider.serviceCategories.isEmpty)
                                            TableRow(
                                              children: [
                                                for (int i = 0; i < 6; i++)
                                                  Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Center(
                                                      child: Text(
                                                        i == 2 ? 'No data available' : '',
                                                        style: const TextStyle(color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            )
                                          else
                                            for (int i = 0; i < provider.serviceCategories.length; i++)
                                              TableRow(
                                                decoration: BoxDecoration(
                                                  color: i.isEven ? Colors.grey.shade200 : Colors.grey.shade100,
                                                ),
                                                children: [
                                                  _buildCell2(
                                                    _formatDate(provider.serviceCategories[i]['date']),
                                                    _formatTime(provider.serviceCategories[i]['date']),
                                                    centerText2: true,
                                                  ),
                                                  _buildCell3(
                                                    provider.serviceCategories[i]['service_provider_name'] ?? '',
                                                    provider.serviceCategories[i]['ref_id'] ?? '',
                                                    copyable: true,
                                                  ),
                                                  _buildCell(provider.serviceCategories[i]['service_name']),
                                                  _buildPriceWithAdd(provider.serviceCategories[i]['quotation'] ?? ''),
                                                  _buildCell(
                                                    provider.serviceCategories[i]['ref_id'] ?? '',
                                                    copyable: true,
                                                  ),
                                                  _buildActionCell(
                                                    onEdit: () {
                                                      _showAddServiceCategoryDialog(
                                                        context,
                                                        editData: provider.serviceCategories[i],
                                                      );
                                                    },
                                                    onDelete: () async {
                                                      final shouldDelete = await showDialog<bool>(
                                                        context: context,
                                                        builder:
                                                            (context) => const ConfirmationDialog(
                                                              title: 'Confirm Deletion',
                                                              content: 'Are you sure you want to delete this?',
                                                              cancelText: 'Cancel',
                                                              confirmText: 'Delete',
                                                            ),
                                                      );
                                                      if (shouldDelete == true) {
                                                        provider.deleteServiceCategory(
                                                          refId: provider.serviceCategories[i]['ref_id'],
                                                        );
                                                      }
                                                    },
                                                    onDraft: () {
                                                      // Additional draft functionality
                                                    },
                                                  ),
                                                ],
                                              ),
                                        ],
                                      ),
                                    ),
                                  ),
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
    );
  }

  Widget _buildHeader(String text) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          text,
          style: const TextStyle(color: AppColors.redColor, fontWeight: FontWeight.bold, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPriceWithAdd(String price, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/dirham_symble.svg', height: 12, width: 12),

          Text(' $price', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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

  Widget _buildCell2(String text1, String text2, {bool copyable = false, bool centerText2 = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
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
                        padding: const EdgeInsets.only(left: 8),
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
                        child: Icon(Icons.copy, size: 8, color: Colors.blue[700]),
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

  Widget _buildActionCell({VoidCallback? onEdit, VoidCallback? onDelete, VoidCallback? onDraft}) {
    return Row(
      children: [
        /* IconButton(
          icon: const Icon(Icons.delete, size: 20, color: AppColors.redColor),
          tooltip: 'Delete',
          onPressed: onDelete ?? () {},
        ),*/
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.green),
          tooltip: 'Edit',
          onPressed: onEdit ?? () {},
        ),
      ],
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
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }
}
