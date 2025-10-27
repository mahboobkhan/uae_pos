import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers/documents_provider.dart';
import '../../../utils/pin_verification_util.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/date_picker.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch documents when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDocuments();
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    _editFileNameController.dispose();
    _editIssueDateController.dispose();
    _editExpiryDateController.dispose();
    super.dispose();
  }

  // Fetch documents using getDocumentsByIds
  Future<void> _fetchDocuments() async {
    final documentsProvider = Provider.of<DocumentsProvider>(context, listen: false);

    try {
      // First, try to get all available document IDs
      print('Fetching all available document IDs...');

      await documentsProvider.getDocuments();
    } catch (e) {
      print('Error fetching documents: $e');
      // Show error message to user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching documents: $e'), backgroundColor: Colors.red));
    }
  }

  // Download file functionality - opens URL in new tab
  Future<void> _downloadFile(Map<String, dynamic> document) async {
    // Get the file URL from the document
    String? fileUrl = document['file_url'] ?? 
                      document['url'] ?? 
                      document['download_url'] ?? 
                      document['path'];
    
    if (fileUrl == null || fileUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file URL found for this document'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    print('Opening URL in new tab: $fileUrl');
    
    // Open URL in new tab
    try {
      final uri = Uri.parse(fileUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening file in new tab...'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot open URL'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('Error opening URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Alternative method to fetch documents using getClientDocuments
  Future<void> _fetchDocumentsByClient() async {
    final documentsProvider = Provider.of<DocumentsProvider>(context, listen: false);

    try {
      // Try with a sample client ID - you can replace this with actual client ID
      String clientId = "sample_client_001";
      print('Fetching documents for client: $clientId');
      await documentsProvider.getClientDocuments(clientRefId: clientId);
    } catch (e) {
      print('Error fetching documents by client: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching documents: $e'), backgroundColor: Colors.red));
    }
  }

  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
  ];

  final List<String> categories = ['All', 'New', 'Pending', 'Completed', 'Stop'];
  String? selectedCategory;

  final List<String> categories1 = ['No Tags', 'Tag 001', 'Tag 002', 'Sample Tag'];
  String? selectedCategory1;
  final List<String> categories3 = ['All', 'Toady', 'Yesterday', 'Last 7 Days', 'Last 30 Days', 'Custom Range'];
  String? selectedCategory3;
  bool _isHovering = false;

  // Edit dialog controllers
  final _editFileNameController = TextEditingController();
  final _editIssueDateController = TextEditingController();
  final _editExpiryDateController = TextEditingController();

  String formatDateTime(DateTime? dt) {
    final now = DateTime.now();
    return DateFormat('dd-MM-yyyy – hh:mm a').format(dt ?? now);
  }

  Future<void> _pickEditDateTime(bool isIssueDate) async {
    DateTime now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;

    final selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    final formatted = DateFormat('dd-MM-yyyy – hh:mm a').format(selectedDateTime);

    setState(() {
      if (isIssueDate) {
        _editIssueDateController.text = formatted;
      } else {
        _editExpiryDateController.text = formatted;
      }
    });
  }

  void _showEditDialog(String fileId, String fileName, String issueDate, String expiryDate) {
    print('Edit dialog called with: ID: $fileId, Name: $fileName, Issue: $issueDate, Expiry: $expiryDate');

    // Store original values for comparison
    final originalFileName = fileName;
    final originalIssueDate = issueDate;
    final originalExpiryDate = expiryDate;

    // Pre-populate the controllers with current values
    _editFileNameController.text = fileName;
    _editIssueDateController.text = issueDate;
    _editExpiryDateController.text = expiryDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.edit, color: Colors.blue),
              const SizedBox(width: 8),
              const Text('Edit Document Details'),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Document Information Header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Document Information',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.fingerprint, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text('File ID: $fileId', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.description, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'File Name: $fileName',
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Editable Fields
                  const Text('Edit Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _editFileNameController,
                    decoration: const InputDecoration(
                      labelText: 'File Name',
                      hintText: 'Enter file name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _editIssueDateController,
                    decoration: const InputDecoration(
                      labelText: 'Issue Date',
                      hintText: 'Select issue date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.edit_calendar),
                    ),
                    readOnly: true,
                    onTap: () => _pickEditDateTime(true),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _editExpiryDateController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'Select expiry date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event),
                      suffixIcon: Icon(Icons.edit_calendar),
                    ),
                    readOnly: true,
                    onTap: () => _pickEditDateTime(false),
                  ),

                  const SizedBox(height: 20),

                  // Document Status Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Document Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text('Issue Date: $issueDate'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 16, color: Colors.red),
                            const SizedBox(width: 8),
                            Text('Expiry Date: $expiryDate'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.info, size: 16, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text('Source Form: N/A'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Check if any values were changed
                final hasChanges = _editFileNameController.text != originalFileName ||
                                  _editIssueDateController.text != originalIssueDate ||
                                  _editExpiryDateController.text != originalExpiryDate;
                
                if (hasChanges) {
                  // Show PIN verification for changes
                  Navigator.of(context).pop(); // Close dialog first
                  
                  PinVerificationUtil.executeWithPinVerification(
                    context,
                    () {
                      // Save the changes
                      print('Saving changes:');
                      print('File Name: ${_editFileNameController.text}');
                      print('Issue Date: ${_editIssueDateController.text}');
                      print('Expiry Date: ${_editExpiryDateController.text}');
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Document "${_editFileNameController.text}" updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    title: 'Confirm Changes',
                    message: 'Please enter your PIN to save these changes',
                  );
                } else {
                  // No changes, just close without saving
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No changes to save'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
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
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CustomDropdown(
                                selectedValue: selectedCategory,
                                hintText: "Status",
                                items: categories,
                                onChanged: (newValue) {
                                  setState(() => selectedCategory = newValue!);
                                },
                              ),
                              CustomDropdown(
                                selectedValue: selectedCategory1,
                                hintText: "Select Tags",
                                items: categories1,
                                onChanged: (newValue) {
                                  setState(() => selectedCategory1 = newValue!);
                                },
                              ),
                              CustomDropdown(
                                selectedValue: selectedCategory3,
                                hintText: "Dates",
                                items: categories3,
                                onChanged: (newValue) async {
                                  if (newValue == 'Custom Range') {
                                    final selectedRange = await showDateRangePickerDialog(context);

                                    if (selectedRange != null) {
                                      final start = selectedRange.startDate ?? DateTime.now();
                                      final end = selectedRange.endDate ?? start;

                                      final formattedRange =
                                          '${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}';

                                      setState(() {
                                        selectedCategory3 = formattedRange;
                                      });
                                    }
                                  } else {
                                    setState(() => selectedCategory3 = newValue!);
                                  }
                                },
                                icon: const Icon(Icons.calendar_month, size: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Card(
                            elevation: 4,
                            color: Colors.green,
                            shape: CircleBorder(),
                            child: Tooltip(
                              message: 'Refresh',
                              waitDuration: Duration(milliseconds: 2),
                              child: GestureDetector(
                                onTap: () {
                                  _fetchDocuments();

                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                  child: const Center(child: Icon(Icons.refresh, color: Colors.white, size: 20)),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            color: Colors.orange,
                            shape: CircleBorder(),
                            child: Tooltip(
                              message: 'Clear Filters',
                              waitDuration: Duration(milliseconds: 2),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                  child: const Center(child: Icon(Icons.clear, color: Colors.white, size: 20)),
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

              Expanded(
                child: Consumer<DocumentsProvider>(
                  builder: (context, documentsProvider, child) {
                    if (documentsProvider.isLoading) {
                      return const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()));
                    }

                    if (documentsProvider.errorMessage != null) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            children: [
                              Text('Error: ${documentsProvider.errorMessage}', style: const TextStyle(color: Colors.red)),
                              const SizedBox(height: 10),
                              ElevatedButton(onPressed: _fetchDocuments, child: const Text('Retry')),
                            ],
                          ),
                        ),
                      );
                    }

                    final documents = documentsProvider.documents;
                    if (documents.isEmpty) {
                      return const Padding(padding: EdgeInsets.all(20), child: Center(child: Text('No documents found')));
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Container(
                        width: double.infinity,
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
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(minWidth: 1150),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    controller: _verticalController,
                                    child: Table(
                                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                      columnWidths: const {
                                        0: FlexColumnWidth(1.5),
                                        1: FlexColumnWidth(1.5),
                                        2: FlexColumnWidth(1),
                                        3: FlexColumnWidth(1),
                                        4: FlexColumnWidth(1.3),
                                        5: FlexColumnWidth(1),
                                        6: FlexColumnWidth(1),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(color: Colors.red.shade50),
                                          children: [
                                            _buildHeader("File Id"),
                                            _buildHeader("File Name"),
                                            _buildHeader("Issue Date"),
                                            _buildHeader("Expiry Date"),
                                            _buildHeader("Source Form"),
                                            _buildHeader("Download Price"),
                                            _buildHeader("Action"),
                                          ],
                                        ),
                                        for (int i = 0; i < documents.length; i++)
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color: i.isEven ? Colors.grey.shade200 : Colors.grey.shade100,
                                            ),
                                            children: [
                                              _buildCell(documents[i]['document_ref_id'] ?? 'N/A', copyable: true),
                                              _buildCell(documents[i]['name'] ?? 'N/A', copyable: false),
                                              _buildCell(documents[i]['issue_date'] ?? 'N/A'),
                                              _buildCell(documents[i]['expire_date'] ?? 'N/A'),
                                              _buildCell(documents[i]['type'] ?? 'N/A'),
                                              _buildDownloadCell("Click Download", () {
                                                _downloadFile(documents[i]);
                                              }),
                                              _buildActionCell(
                                                onEdit: () {
                                                  _showEditDialog(
                                                    documents[i]['document_ref_id'] ?? 'N/A',
                                                    documents[i]['name'] ?? 'N/A',
                                                    documents[i]['issue_date'] ?? 'N/A',
                                                    documents[i]['expire_date'] ?? 'N/A',
                                                  );
                                                },
                                                onDelete: () async {
                                                  await PinVerificationUtil.executeWithPinVerification(
                                                    context,
                                                    () async {
                                                      final documentsProvider = Provider.of<DocumentsProvider>(
                                                        context,
                                                        listen: false,
                                                      );
                                                      final success = await documentsProvider.deleteDocument(
                                                        documentRefId: documents[i]['document_ref_id'] ?? '',
                                                      );
                                                      if (success) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('Document deleted successfully')),
                                                        );
                                                        _fetchDocuments();
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              documentsProvider.errorMessage ?? 'Failed to delete document',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    title: 'Delete Document',
                                                    message: 'Please enter your PIN to delete this document',
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
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
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
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.copy, size: 10, color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionCell({VoidCallback? onEdit, VoidCallback? onDelete}) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✏️ Edit Button with Tooltip
          Tooltip(
            message: 'Edit',
            waitDuration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: onEdit ?? () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.edit, size: 20, color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 🗑️ Delete Button with Tooltip
          Tooltip(
            message: 'Delete',
            waitDuration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: onDelete ?? () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.delete, size: 20, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadCell(String text, VoidCallback onDownload) {
    return GestureDetector(
      onTap: onDownload,
      child: Container(
        padding: const EdgeInsets.only(left: 4.0),
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.download, size: 16, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
