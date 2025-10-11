import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ShortServicesProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/projects/short_services";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> shortServices = [];

  /// ✅ Get All Short Services
  Future<void> getAllShortServices() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/get_short_services.php");

    try {
      if (kDebugMode) {
        print('Fetching short services from: $url');
      }
      
      final response = await http.get(url);
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['data'] != null && data['data'] is List && data['data'].isNotEmpty) {
            shortServices = List<Map<String, dynamic>>.from(data['data']);
            successMessage = "Short services fetched successfully";
            if (kDebugMode) {
              print('Fetched ${shortServices.length} short services');
            }
          } else {
            shortServices = [];
            errorMessage = "No short services available";
            if (kDebugMode) {
              print('No short services data in response');
            }
          }
        } else {
          errorMessage = data['message'] ?? "Failed to fetch data";
          if (kDebugMode) {
            print('API returned error: $errorMessage');
          }
        }
      } else {
        errorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
        if (kDebugMode) {
          print('HTTP error: $errorMessage');
        }
      }
    } catch (e) {
      errorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Add Short Service (Single or Multiple)
  Future<void> addShortService({
    required String userRefId,
    required List<Map<String, dynamic>> services,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_short_service.php");

    final body = json.encode({
      "user_ref_id": userRefId,
      "services": services,
    });

    try {
      if (kDebugMode) {
        print('Adding short service to: $url');
        print('Request body: $body');
      }
      
      final response = await http.post(
        url, 
        headers: {"Content-Type": "application/json"}, 
        body: body
      );
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Short service added successfully";
        await getAllShortServices(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to add short service";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Update Short Service
  Future<void> updateShortService({
    required String userRefId,
    required String refId,
    required String clientName,
    required String quotation,
    required String managerName,
    String? paymentMethod,
    String? paymentStatus,
    String? transactionId,
    String? bankRefId,
    String? chequeNo,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_short_service.php");

    final Map<String, dynamic> requestBody = {
      "user_ref_id": userRefId,
      "ref_id": refId,
      "client_name": clientName,
      "quotation": quotation,
      "manager_name": managerName,
    };

    // Add optional payment fields if provided
    if (paymentMethod != null) requestBody["payment_method"] = paymentMethod;
    if (paymentStatus != null) requestBody["payment_status"] = paymentStatus;
    if (transactionId != null) requestBody["transaction_id"] = transactionId;
    if (bankRefId != null) requestBody["bank_ref_id"] = bankRefId;
    if (chequeNo != null) requestBody["cheque_no"] = chequeNo;

    final body = json.encode(requestBody);

    try {
      if (kDebugMode) {
        print('Updating short service at: $url');
        print('Request body: $body');
      }
      
      final response = await http.post(
        url, 
        headers: {"Content-Type": "application/json"}, 
        body: body
      );
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Short service updated successfully";
        await getAllShortServices(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to update short service";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Delete Short Service
  Future<void> deleteShortService({
    required String userRefId,
    required String refId,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/delete_short_service.php");

    final body = json.encode({
      "user_ref_id": userRefId,
      "ref_id": refId,
    });

    try {
      if (kDebugMode) {
        print('Deleting short service at: $url');
        print('Request body: $body');
      }
      
      final response = await http.post(
        url, 
        headers: {"Content-Type": "application/json"}, 
        body: body
      );
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Short service deleted successfully";
        await getAllShortServices(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to delete short service";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// Clear messages
  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
