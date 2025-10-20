import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../providers/client_profile_provider.dart';
import '../../../providers/documents_provider.dart';
import '../../dialogs/calender.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/custom_fields.dart';
import '../../../utils/pin_verification_util.dart';

Future<void> showIndividualProfileDialog(BuildContext context, {Map<String, dynamic>? clientData}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: IndividualProfileDialog(clientData: clientData),
      );
    },
  );
}

class IndividualProfileDialog extends StatefulWidget {
  final Map<String, dynamic>? clientData;

  const IndividualProfileDialog({super.key, this.clientData});

  @override
  State<IndividualProfileDialog> createState() => _IndividualProfileDialogState();
}

class _IndividualProfileDialogState extends State<IndividualProfileDialog> {
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController channelNameController = TextEditingController();
  final TextEditingController channelLoginController = TextEditingController();
  final TextEditingController advancePaymentController = TextEditingController();
  final TextEditingController channelPasswordController = TextEditingController();
  final TextEditingController _physicalAddressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController emiratesIdController = TextEditingController();
  final TextEditingController emailId = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();
  final TextEditingController contactNumber2 = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _createdDateController = TextEditingController();

  // Document related variables
  List<String> uploadedDocumentIds = [];
  List<Map<String, dynamic>> clientDocuments = [];
  dynamic selectedFile; // Use dynamic to handle both File and PlatformFile
  String? selectedFileName;
  Uint8List? selectedFileBytes; // For web compatibility
  bool _isProcessing = false;
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController documentIssueDateController = TextEditingController();
  final TextEditingController documentExpiryDateController = TextEditingController();

  // Edit mode state
  bool _isEditMode = true;

  // Original values for change detection
  Map<String, String?> _originalValues = {};

  bool _hasEditsMade() {
    String? norm(String? v) => (v ?? '').trim();
    return (
      norm(clientNameController.text) != norm(_originalValues['name']) ||
      norm(emailId.text) != norm(_originalValues['email']) ||
      norm(contactNumber.text) != norm(_originalValues['phone1']) ||
      norm(contactNumber2.text) != norm(_originalValues['phone2']) ||
      norm(_physicalAddressController.text) != norm(_originalValues['physical_address']) ||
      norm(_noteController.text) != norm(_originalValues['extra_note']) ||
      norm(channelNameController.text) != norm(_originalValues['echannel_name']) ||
      norm(channelLoginController.text) != norm(_originalValues['echannel_id']) ||
      norm(channelPasswordController.text) != norm(_originalValues['echannel_password']) ||
      norm(selectedWorkType) != norm(_originalValues['client_work'])
    );
  }

  void _pickDateTime2() {
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

  // Document related methods
  Future<void> _pickFile() async {
    try {
      // Check and request storage permission first (skip on web)
      if (!kIsWeb) {
        bool hasPermission = await _checkStoragePermission();
        if (!hasPermission) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage permission is required to select files'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      // Use a more robust file picker approach
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'tif'],
        allowMultiple: false,
        withData: true,
        // Always get file data for web compatibility
        withReadStream: false,
        allowCompression: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        setState(() {
          if (kIsWeb) {
            // For web, use PlatformFile directly
            selectedFile = file;
            selectedFileBytes = file.bytes;
            selectedFileName = file.name;
          } else {
            // For mobile, use File
            if (file.path != null && file.path!.isNotEmpty) {
              selectedFile = File(file.path!);
              selectedFileName = file.name;
            }
          }
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File selected: ${file.name}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('File picker error: $e'); // Debug print

      // Handle specific error types
      String errorMessage = 'Error picking file';
      if (e.toString().contains('LateInitializationError')) {
        errorMessage = 'File picker not initialized. Please restart the app.';
      } else if (e.toString().contains('Permission')) {
        errorMessage = 'Permission denied. Please check app permissions.';
      } else {
        errorMessage = 'Error picking file: ${e.toString()}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red, duration: const Duration(seconds: 4)),
      );
    }
  }

  // Check and request storage permission
  Future<bool> _checkStoragePermission() async {
    try {
      // For Android 13+ (API 33+), use media permissions
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (status.isDenied) {
          status = await Permission.storage.request();
        }

        // Also check for media permissions for newer Android versions
        var mediaStatus = await Permission.photos.status;
        if (mediaStatus.isDenied) {
          mediaStatus = await Permission.photos.request();
        }

        return status.isGranted || mediaStatus.isGranted;
      } else if (Platform.isIOS) {
        var status = await Permission.photos.status;
        if (status.isDenied) {
          status = await Permission.photos.request();
        }
        return status.isGranted;
      }

      return true; // For other platforms, assume permission is granted
    } catch (e) {
      print('Permission check error: $e');
      return true; // If permission check fails, try anyway
    }
  }

  Future<void> _uploadDocument() async {
    if (_isProcessing) return; // Prevent multiple simultaneous uploads

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

    // Add a small delay to allow UI to settle before starting upload
    await Future.delayed(const Duration(milliseconds: 100));

    final documentsProvider = context.read<DocumentsProvider>();
    String? documentRefId;

    try {
      if (kIsWeb) {
        // Web platform: use file bytes
        if (selectedFileBytes != null) {
          documentRefId = await documentsProvider.addDocumentWeb(
            name: documentNameController.text.trim(),
            issueDate:
                documentIssueDateController.text.trim().isNotEmpty
                    ? documentIssueDateController.text.trim()
                    : DateFormat('yyyy-MM-dd').format(DateTime.now()),
            expireDate:
                documentExpiryDateController.text.trim().isNotEmpty
                    ? documentExpiryDateController.text.trim()
                    : DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 365))),
            fileBytes: selectedFileBytes!,
            fileName: selectedFileName ?? 'document',
          );
        }
      } else {
        // Mobile platform: use File
        if (selectedFile is File) {
          documentRefId = await documentsProvider.addDocument(
            name: documentNameController.text.trim(),
            issueDate:
                documentIssueDateController.text.trim().isNotEmpty
                    ? documentIssueDateController.text.trim()
                    : DateFormat('yyyy-MM-dd').format(DateTime.now()),
            expireDate:
                documentExpiryDateController.text.trim().isNotEmpty
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
              action: SnackBarAction(label: 'Retry', textColor: Colors.white, onPressed: () => _uploadDocument()),
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
            action: SnackBarAction(label: 'Retry', textColor: Colors.white, onPressed: () => _uploadDocument()),
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

  Future<void> _loadClientDocuments() async {
    if (widget.clientData != null && widget.clientData!['client_ref_id'] != null) {
      final documentsProvider = context.read<DocumentsProvider>();

      // First try to get documents from the documents field in client data
      if (widget.clientData!['documents'] != null) {
        try {
          // Parse the documents string (it's a JSON string like ["DD-20250918-9883"])
          final documentsString = widget.clientData!['documents'].toString();
          if (documentsString.isNotEmpty && documentsString != 'null') {
            final List<dynamic> documentIds = json.decode(documentsString);
            if (documentIds.isNotEmpty) {
              // Use the new API to get full document details
              final fetchedDocuments = await documentsProvider.getDocumentsByIds(
                documentRefIds: documentIds.cast<String>(),
              );

              if (mounted && fetchedDocuments != null) {
                setState(() {
                  clientDocuments = fetchedDocuments;
                });
                return; // Successfully loaded documents, exit early
              }
            }
          }
        } catch (e) {
          print('Error parsing documents from client data: $e');
        }
      }

      // Fallback to the old method if documents field is not available or parsing failed
      await documentsProvider.getClientDocuments(clientRefId: widget.clientData!['client_ref_id'].toString());

      if (mounted) {
        setState(() {
          clientDocuments = documentsProvider.documents;
        });
      }
    }
  }

  Future<void> _deleteDocument(String documentRefId) async {
    final documentsProvider = context.read<DocumentsProvider>();
    final success = await documentsProvider.deleteDocument(documentRefId: documentRefId);

    if (success) {
      setState(() {
        clientDocuments.removeWhere((doc) => doc['document_ref_id'] == documentRefId);
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

  // Document button state management
  void _handleDocumentAction() {
    if (selectedFile == null) {
      // No file selected - pick file
      _pickFileWithFallback();
    } else if (documentNameController.text.trim().isEmpty) {
      // File selected but no name - show validation
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter document name')));
    } else {
      // File selected and name entered - upload with post-frame callback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _uploadDocument();
      });
    }
  }

  // Fallback file picker method
  Future<void> _pickFileWithFallback() async {
    try {
      await _pickFile();
    } catch (e) {
      // If the main file picker fails, try alternative approach
      print('Main file picker failed, trying alternative: $e');
      await _pickFileAlternative();
    }
  }

  // Alternative file picker method
  Future<void> _pickFileAlternative() async {
    try {
      // Try with different file type
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: false,
        withReadStream: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null && file.path!.isNotEmpty) {
          setState(() {
            selectedFile = File(file.path!);
            selectedFileName = file.name;
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('File selected: ${file.name}'), backgroundColor: Colors.green));
        }
      }
    } catch (e) {
      print('Alternative file picker also failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to access file picker. Please check app permissions or restart the app.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
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
    // For now, show a message. In a real app, you would implement actual download
    final downloadUrl = url ?? 'No URL available';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading document: $documentRefId\nURL: $downloadUrl'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String? selectedWorkType;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedJobType2;

  @override
  void initState() {
    super.initState();
    final data = widget.clientData;
    if (data != null) {
      clientNameController.text = (data['name'] ?? '').toString();
      emailId.text = (data['email'] ?? '').toString();
      contactNumber.text = (data['phone1'] ?? '').toString();
      contactNumber2.text = (data['phone2'] ?? '').toString();
      _physicalAddressController.text = (data['physical_address'] ?? '').toString();
      _noteController.text = (data['extra_note'] ?? '').toString();
      channelNameController.text = (data['echannel_name'] ?? '').toString();
      channelLoginController.text = (data['echannel_id'] ?? '').toString();
      channelPasswordController.text = (data['echannel_password'] ?? '').toString();
      selectedWorkType = (data['client_work'] ?? 'N/A').toString();

      _originalValues = {
        'name': (data['name'] ?? '').toString(),
        'email': (data['email'] ?? '').toString(),
        'phone1': (data['phone1'] ?? '').toString(),
        'phone2': (data['phone2'] ?? '').toString(),
        'physical_address': (data['physical_address'] ?? '').toString(),
        'extra_note': (data['extra_note'] ?? '').toString(),
        'echannel_name': (data['echannel_name'] ?? '').toString(),
        'echannel_id': (data['echannel_id'] ?? '').toString(),
        'echannel_password': (data['echannel_password'] ?? '').toString(),
        'client_work': (data['client_work'] ?? '').toString(),
      };

      // Set created date from client data if available, otherwise use current date
      if (data['created_at'] != null && data['created_at'].toString().isNotEmpty) {
        try {
          final createdDate = DateTime.parse(data['created_at'].toString());
          _createdDateController.text = DateFormat('dd-MM-yyyy').format(createdDate);
        } catch (e) {
          _createdDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
        }
      } else {
        _createdDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
      }

      // Load existing documents if editing
      _loadClientDocuments();
    } else {
      // For new clients, set current date
      _createdDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    }

    // Reset provider state when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final documentsProvider = context.read<DocumentsProvider>();
      documentsProvider.resetLoadingState();
    });
  }

  @override
  void dispose() {
    // Reset provider state when dialog closes
    final documentsProvider = context.read<DocumentsProvider>();
    documentsProvider.resetLoadingState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 950,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Individual Profile',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 160,
                        child: SmallDropdownField(
                          label: "Client Type",
                          options: ['N/A','Regular', 'Walking'],
                          selectedValue: selectedWorkType,
                          enabled: _isEditMode,
                          onChanged: (value) {
                            setState(() {
                              selectedWorkType = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _createdDateController.text,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14),
                      ),
                      const SizedBox(width: 12),
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
              Text(widget.clientData?["client_ref_id"] ?? "", style: TextStyle(fontSize: 12)),
              /*const SizedBox(height: 12),
              // Created Date Field
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomDateNotificationField(
                    label: "Created Date",
                    controller: _createdDateController,
                    readOnly: true,
                    hintText: "dd-MM-yyyy",
                  ),
                ],
              ),*/
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CustomTextField(label: "Client Name", hintText: "", controller: clientNameController, enabled: _isEditMode),
                  CustomTextField(label: "Emirates ID ", controller: emiratesIdController, hintText: "", enabled: _isEditMode),
                  CustomTextField(label: "Email ID ", controller: emailId, hintText: "", enabled: _isEditMode),
                  CustomTextField(label: "Contact Number ", controller: contactNumber, hintText: "", enabled: _isEditMode),
                  CustomTextField(label: "Contact Number 2", controller: contactNumber2, hintText: "", enabled: _isEditMode),
                  CustomTextField(label: "E- Channel Name", controller: channelNameController, hintText: "", enabled: _isEditMode),
                  CustomTextField(label: "E- Channel Login I'd", controller: channelLoginController, hintText: "", enabled: _isEditMode),
                  CustomTextField(
                    label: "E- Channel Login Password",
                    controller: channelPasswordController,
                    hintText: "",
                    enabled: _isEditMode,
                  ),
                  CustomTextField(label: "Advance Payment TID", controller: advancePaymentController, hintText: "", enabled: _isEditMode),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: 450,
                    child: CustomTextField(
                      label: "Physical Address",
                      hintText: "Address,house,street,town,post code",
                      controller: _physicalAddressController,
                      enabled: _isEditMode,
                    ),
                  ),
                  SizedBox(
                    width: 450,
                    child: CustomTextField(label: "Note / Extra", controller: _noteController, hintText: '', enabled: _isEditMode),
                  ),
                ],
              ),
              /*SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  InfoBox(value: "Pending Payment", label: "AED-3000", color: Colors.blue.shade50),
                  InfoBox(value: "Advance Payment", label: "AED-3000", color: Colors.blue.shade50),
                ],
              ),*/
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      CustomDateNotificationField(
                        label: "Issue Date Notifications",
                        controller: _issueDateController,
                        readOnly: true,
                        hintText: "dd-MM-yyyy HH:mm",
                        onTap: _pickDateTime2,
                      ),
                      CustomDateNotificationField(
                        label: "Expiry Date Notifications",
                        controller: _expiryDateController,
                        readOnly: true,
                        hintText: "dd-MM-yyyy HH:mm",
                        onTap: _pickDateTime2,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),*/

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
                              hintText: "e.g., Trade License Copy",
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
                                          onTap:
                                              (documentsProvider.isUploading || _isProcessing)
                                                  ? null
                                                  : () {
                                                    // Use a microtask to ensure proper timing
                                                    Future.microtask(() {
                                                      _handleDocumentAction();
                                                    });
                                                  },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // color: (documentsProvider.isUploading || _isProcessing) ? Colors.grey : _getDocumentButtonColor(),
                                              color: Colors.grey,
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
                ],
              ),
              SizedBox(height: 20),

              // Document List Section
              if (clientDocuments.isNotEmpty || uploadedDocumentIds.isNotEmpty)
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
                          ...clientDocuments.map(
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
                    const SizedBox(height: 20),
                  ],
                ),

              Row(
                children: [
                  CustomButton(
                    text: "Cancel",
                    backgroundColor: Colors.grey,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: "Submit",
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      final provider = context.read<ClientProfileProvider>();
                      final isEdit = widget.clientData != null &&
                          (widget.clientData!['client_ref_id']?.toString().isNotEmpty ?? false);

                      final allDocumentIds = [
                        ...clientDocuments.map((doc) => doc['document_ref_id']?.toString()).where((id) => id != null).cast<String>(),
                        ...uploadedDocumentIds,
                      ];

                      final bool isNA = (selectedWorkType == 'N/A');

                      Future<void> performSave() async {
                        if (isEdit) {
                          await provider.updateClient(
                            clientRefId: widget.clientData!['client_ref_id'].toString(),
                            name: isNA ? null : (clientNameController.text.trim().isNotEmpty ? clientNameController.text.trim() : null),
                            email: isNA ? null : (emailId.text.trim().isNotEmpty ? emailId.text.trim() : null),
                            phone1: isNA ? null : (contactNumber.text.trim().isNotEmpty ? contactNumber.text.trim() : null),
                            phone2: isNA ? null : (contactNumber2.text.trim().isNotEmpty ? contactNumber2.text.trim() : null),
                            clientType: 'individual',
                            clientWork: isNA ? null : (selectedWorkType ?? 'Regular').toLowerCase(),
                            physicalAddress: isNA ? null : (_physicalAddressController.text.trim().isNotEmpty ? _physicalAddressController.text.trim() : null),
                            echannelName: isNA ? null : (channelNameController.text.trim().isNotEmpty ? channelNameController.text.trim() : null),
                            echannelId: isNA ? null : (channelLoginController.text.trim().isNotEmpty ? channelLoginController.text.trim() : null),
                            echannelPassword: isNA ? null : (channelPasswordController.text.trim().isNotEmpty ? channelPasswordController.text.trim() : null),
                            extraNote: isNA ? null : (_noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null),
                            documents: allDocumentIds,
                          );
                        } else {
                          await provider.addClient(
                            name: isNA ? 'N/A' : (clientNameController.text.trim().isNotEmpty ? clientNameController.text.trim() : 'N/A'),
                            clientType: 'individual',
                            clientWork: isNA ? '' : (selectedWorkType ?? 'Regular').toLowerCase(),
                            email: isNA ? '' : (emailId.text.trim().isNotEmpty ? emailId.text.trim() : 'no-email@example.com'),
                            phone1: isNA ? '' : (contactNumber.text.trim().isNotEmpty ? contactNumber.text.trim() : '+000000000'),
                            phone2: isNA ? null : (contactNumber2.text.trim().isNotEmpty ? contactNumber2.text.trim() : null),
                            physicalAddress: isNA ? null : (_physicalAddressController.text.trim().isNotEmpty ? _physicalAddressController.text.trim() : null),
                            echannelName: isNA ? null : (channelNameController.text.trim().isNotEmpty ? channelNameController.text.trim() : null),
                            echannelId: isNA ? null : (channelLoginController.text.trim().isNotEmpty ? channelLoginController.text.trim() : null),
                            echannelPassword: isNA ? null : (channelPasswordController.text.trim().isNotEmpty ? channelPasswordController.text.trim() : null),
                            extraNote: isNA ? null : (_noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null),
                            documents: allDocumentIds,
                          );
                        }
                      }

                      if (isEdit && _hasEditsMade()) {
                        await PinVerificationUtil.executeWithPinVerification(
                          context,
                          () async {
                            await performSave();
                          },
                          title: "Update Client",
                          message: "Please enter your PIN to update this client",
                        );
                      } else {
                        await performSave();
                      }

                      if (provider.errorMessage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(provider.successMessage ?? (isEdit ? 'Client updated' : 'Client created'))),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(backgroundColor: Colors.red, content: Text(provider.errorMessage!)),
                        );
                      }
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

  Widget _buildTextField(String label) {
    return SizedBox(
      width: 250,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red),
          // Label color
          isDense: true,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            // Red border on focus
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomDropdownField(
          label: "Type",
          items: ['Regular', 'Walking'],
          selectedValue: selectedJobType2,
          onChanged: (value) {
            setState(() {
              selectedJobType2 = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaymentRow() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildPaymentTile("Pending Payments", "9700", Colors.red),
        _buildPaymentTile("Advance Payment", "10,000", Colors.green),
      ],
    );
  }

  Widget _buildPaymentTile(String title, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadRow() {
    return Wrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Icon(Icons.calendar_month, color: Colors.red, size: 20),
        const Text("12-02-2025 - 02:59 pm"),
        const Icon(Icons.calendar_month, color: Colors.red, size: 20),
        const Text("12-02-2025 - 02:59 pm"),
        const Icon(Icons.check_circle, color: Colors.green, size: 24),
        CustomButton(
          text: 'Upload File',
          onPressed: () {},
          backgroundColor: Colors.green,
          icon: Icons.file_copy_outlined,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomButton(text: 'Editing', onPressed: () {}, backgroundColor: Colors.blue),
        const SizedBox(width: 20),
        CustomButton(text: 'Submit', onPressed: () {}, backgroundColor: Colors.red),
      ],
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final Color borderColor;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    this.label,
    this.hintText,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 56, // <-- Matches default TextField height
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isDense: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          border: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: 1)),
        ),
        hint: hintText != null ? Text(hintText!) : null,
        icon: const Icon(Icons.arrow_drop_down),
        items:
            items.map((item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
