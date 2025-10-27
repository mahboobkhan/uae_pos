import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DocumentsProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/documents";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> documents = [];
  double uploadProgress = 0.0;
  bool isUploading = false;

  // Upload progress tracking
  void _updateUploadProgress(double progress) {
    uploadProgress = progress;
    notifyListeners();
  }

  // Add document with file upload (mobile version)
  Future<String?> addDocument({
    required String name,
    required String issueDate,
    required String expireDate,
    required File file,
  }) async {
    return await _addDocumentInternal(
      name: name,
      issueDate: issueDate,
      expireDate: expireDate,
      file: file,
      type: 'client',
      fileBytes: null,
      fileName: null,
    );
  }

  // Add document with file upload (web version)
  Future<String?> addDocumentWeb({
    required String name,
    required String issueDate,
    required String expireDate,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    return await _addDocumentInternal(
      name: name,
      issueDate: issueDate,
      expireDate: expireDate,
      file: null,
      type: 'client',
      fileBytes: fileBytes,
      fileName: fileName,
    );
  }

  // Internal method to handle both mobile and web uploads
  Future<String?> _addDocumentInternal({
    required String name,
    required String issueDate,
    required String expireDate,
    required String type,
    File? file,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    isLoading = true;
    isUploading = true;
    errorMessage = null;
    successMessage = null;
    uploadProgress = 0.0;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_document.php");

    try {
      if (kDebugMode) {
        print('Uploading document to: $url');
        if (file != null) {
          print('File: ${file.path}');
        } else {
          print('File bytes: ${fileBytes?.length} bytes');
        }
      }

      // Check if file exists and get file size (skip on web)
      if (!kIsWeb && file != null) {
        if (!await file.exists()) {
          errorMessage = 'File does not exist';
          isLoading = false;
          isUploading = false;
          notifyListeners();
          return null;
        }

        // Check file size (limit to 10MB)
        int fileSize = await file.length();
        if (fileSize > 10 * 1024 * 1024) {
          // 10MB limit
          errorMessage = 'File size too large. Maximum size is 10MB';
          isLoading = false;
          isUploading = false;
          notifyListeners();
          return null;
        }
      }

      // Check file size for web (fileBytes)
      if (kIsWeb && fileBytes != null) {
        if (fileBytes.length > 10 * 1024 * 1024) {
          // 10MB limit
          errorMessage = 'File size too large. Maximum size is 10MB';
          isLoading = false;
          isUploading = false;
          notifyListeners();
          return null;
        }
      }

      var request = http.MultipartRequest('POST', url);
      request.fields['name'] = name;
      request.fields['type'] = type;
      request.fields['issue_date'] = issueDate;
      request.fields['expire_date'] = expireDate;

      // Read file bytes and create multipart file
      try {
        List<int> bytes;
        String filename;

        if (kIsWeb && fileBytes != null) {
          // Web: use provided file bytes
          bytes = fileBytes;
          filename = fileName ?? 'document';
        } else if (file != null) {
          // Mobile: read from file
          bytes = await file.readAsBytes();
          filename = file.path.split('/').last;
        } else {
          throw Exception('No file data provided');
        }

        var multipartFile = http.MultipartFile.fromBytes('file', bytes, filename: filename);
        request.files.add(multipartFile);
      } catch (e) {
        errorMessage = 'Error reading file: ${e.toString()}';
        isLoading = false;
        isUploading = false;
        notifyListeners();
        return null;
      }

      // Track upload progress with timeout
      var streamedResponse = await request.send().timeout(
        const Duration(minutes: 5), // 5 minute timeout
        onTimeout: () {
          throw Exception('Upload timeout - please try again');
        },
      );
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          successMessage = 'Document uploaded successfully';
          uploadProgress = 1.0;
          isLoading = false;
          isUploading = false;
          // Use post frame callback to ensure proper timing
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifyListeners();
          });
          return data['document_ref_id'] as String?;
        } else {
          errorMessage = data['message'] ?? 'Failed to upload document';
        }
      } else {
        errorMessage = 'Upload failed with status: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = "Upload error: $e";
      if (kDebugMode) {
        print('Upload error details: $e');
      }
    }

    // Always reset loading state on error
    isLoading = false;
    isUploading = false;
    uploadProgress = 0.0;
    // Use post frame callback to ensure proper timing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    return null;
  }

  // Update document
  Future<String?> updateDocument({
    required String documentRefId,
    required String name,
    required String issueDate,
    required String expireDate,
    File? file,
  }) async {
    isLoading = true;
    isUploading = file != null;
    errorMessage = null;
    successMessage = null;
    uploadProgress = 0.0;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_document.php");

    try {
      if (kDebugMode) {
        print('Updating document at: $url');
        print('Document ID: $documentRefId');
      }

      var request = http.MultipartRequest('POST', url);
      request.fields['document_ref_id'] = documentRefId;
      request.fields['name'] = name;
      request.fields['issue_date'] = issueDate;
      request.fields['expire_date'] = expireDate;

      if (file != null) {
        // Check if file exists and get file size (skip on web)
        if (!kIsWeb) {
          if (!await file.exists()) {
            errorMessage = 'File does not exist';
            isLoading = false;
            isUploading = false;
            notifyListeners();
            return null;
          }

          // Check file size (limit to 10MB)
          int fileSize = await file.length();
          if (fileSize > 10 * 1024 * 1024) {
            // 10MB limit
            errorMessage = 'File size too large. Maximum size is 10MB';
            isLoading = false;
            isUploading = false;
            notifyListeners();
            return null;
          }
        }

        // Read file bytes and create multipart file
        try {
          List<int> fileBytes = await file.readAsBytes();
          var multipartFile = http.MultipartFile.fromBytes('file', fileBytes, filename: file.path.split('/').last);
          request.files.add(multipartFile);
        } catch (e) {
          errorMessage = 'Error reading file: ${e.toString()}';
          isLoading = false;
          isUploading = false;
          notifyListeners();
          return null;
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        successMessage = data['message'] ?? 'Document updated successfully';
        uploadProgress = 1.0;
        return data['document_ref_id'] as String?;
      } else {
        errorMessage = data['message'] ?? 'Failed to update document';
      }
    } catch (e) {
      errorMessage = "Update error: $e";
    }

    isLoading = false;
    isUploading = false;
    uploadProgress = 0.0;
    notifyListeners();
    return null;
  }

  // Delete document
  Future<bool> deleteDocument({required String documentRefId}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/delete_document.php");
    final body = json.encode({"document_ref_id": documentRefId});

    try {
      if (kDebugMode) {
        print('Deleting document at: $url');
        print('Request body: $body');
      }

      final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        successMessage = data['message'] ?? 'Document deleted successfully';
        return true;
      } else {
        errorMessage = data['message'] ?? 'Failed to delete document';
        return false;
      }
    } catch (e) {
      errorMessage = "Delete error: $e";
      return false;
    }

    isLoading = false;
    notifyListeners();
    return false;
  }

  // Get documents for a client
  Future<void> getClientDocuments({required String clientRefId}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/get_client_documents.php");
    final body = json.encode({"client_ref_id": clientRefId});

    try {
      if (kDebugMode) {
        print('Fetching client documents from: $url');
        print('Client ID: $clientRefId');
      }

      final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['documents'] != null && data['documents'] is List) {
            documents = List<Map<String, dynamic>>.from(data['documents']);
            successMessage = "Documents fetched";
          } else {
            documents = [];
            errorMessage = "No documents found";
          }
        } else {
          errorMessage = data['message'] ?? "Failed to fetch documents";
        }
      } else {
        errorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  // Get all document IDs (for getting a list of available documents)
  Future<void> getDocuments({
    List<String>? documentRefIds,
    String? type,
    String? typeRefId,
    String? issueDate,
    String? expireDate,
    String? dateFrom,
    String? dateTo,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/get_documents.php");

    // 🔹 Prepare request body based on provided filters
    final Map<String, dynamic> body = {};

    // ✅ Only include document_ref_ids if provided and not empty
    if (documentRefIds != null && documentRefIds.isNotEmpty) {
      body["document_ref_ids"] = documentRefIds;
    }

    if (type != null && type.isNotEmpty) body["type"] = type;
    if (typeRefId != null && typeRefId.isNotEmpty) body["type_ref_id"] = typeRefId;
    if (issueDate != null && issueDate.isNotEmpty) body["issue_date"] = issueDate;
    if (expireDate != null && expireDate.isNotEmpty) body["expire_date"] = expireDate;
    if (dateFrom != null && dateFrom.isNotEmpty) body["date_from"] = dateFrom;
    if (dateTo != null && dateTo.isNotEmpty) body["date_to"] = dateTo;

    try {
      if (kDebugMode) {
        print('Fetching documents by IDs from: $url');
        print('Request body: $body');
      }

      final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(body));

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['documents'] != null && data['documents'] is List) {
            print("document if case");
            documents = List<Map<String, dynamic>>.from(data['documents']);
            successMessage = "Documents fetched successfully";
            isLoading = false;
            notifyListeners();
          } else {
            print("document else case");
            errorMessage = "No documents found";
          }
        } else {
          errorMessage = data['message'] ?? "Failed to fetch documents";
        }
      } else {
        errorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
    }

    isLoading = false;
    notifyListeners();
    return null;
  }

  // Get documents by document reference IDs
  Future<List<Map<String, dynamic>>?> getDocumentsByIds({
    List<String>? documentRefIds,
    String? type,
    String? typeRefId,
    String? issueDate,
    String? expireDate,
    String? dateFrom,
    String? dateTo,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/get_documents.php");

    // 🔹 Prepare request body based on provided filters
    final Map<String, dynamic> body = {};

    // ✅ Only include document_ref_ids if provided and not empty
    if (documentRefIds != null && documentRefIds.isNotEmpty) {
      body["document_ref_ids"] = documentRefIds;
    }

    if (type != null && type.isNotEmpty) body["type"] = type;
    if (typeRefId != null && typeRefId.isNotEmpty) body["type_ref_id"] = typeRefId;
    if (issueDate != null && issueDate.isNotEmpty) body["issue_date"] = issueDate;
    if (expireDate != null && expireDate.isNotEmpty) body["expire_date"] = expireDate;
    if (dateFrom != null && dateFrom.isNotEmpty) body["date_from"] = dateFrom;
    if (dateTo != null && dateTo.isNotEmpty) body["date_to"] = dateTo;

    try {
      if (kDebugMode) {
        print('Fetching documents by IDs from: $url');
        print('Request body: $body');
      }

      final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(body));

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['documents'] != null && data['documents'] is List) {
            print("document if case");
            final fetchedDocuments = List<Map<String, dynamic>>.from(data['documents']);
            successMessage = "Documents fetched successfully";
            isLoading = false;
            notifyListeners();

            return fetchedDocuments;
          } else {
            print("document else case");
            errorMessage = "No documents found";
          }
        } else {
          errorMessage = data['message'] ?? "Failed to fetch documents";
        }
      } else {
        errorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
    }

    isLoading = false;
    notifyListeners();
    return null;
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    uploadProgress = 0.0;
    isUploading = false;
    notifyListeners();
  }

  void resetUploadProgress() {
    uploadProgress = 0.0;
    isUploading = false;
    notifyListeners();
  }

  void resetLoadingState() {
    isLoading = false;
    isUploading = false;
    uploadProgress = 0.0;
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
