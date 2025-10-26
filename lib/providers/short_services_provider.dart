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

  /// ✅ Add Multiple Short Services (Same customer, same ref_id, multiple services)
  Future<void> addMultipleShortServices({
    required String userRefId,
    required String clientName,
    required String managerName,
    required List<Map<String, dynamic>> services,
    String? paymentMethod,
    String? paymentStatus,
    double? paidAmount,
    String? transactionId,
    String? bankRefId,
    String? chequeNo,
    String? clientRef,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_short_service.php");

    final Map<String, dynamic> requestBody = {
      "user_ref_id": userRefId,
      "client_name": clientName,
      "manager_name": managerName,
      "services": services,
    };

    // Add optional payment fields if provided
    if (paymentMethod != null) requestBody["payment_method"] = paymentMethod;
    if (paymentStatus != null) requestBody["payment_status"] = paymentStatus;
    if (paidAmount != null) requestBody["paid_amount"] = paidAmount;
    if (transactionId != null) requestBody["transaction_id"] = transactionId;
    if (bankRefId != null) requestBody["bank_ref_id"] = bankRefId;
    if (chequeNo != null) requestBody["cheque_no"] = chequeNo;
    if (clientRef != null) requestBody["client_ref"] = clientRef;

    final body = json.encode(requestBody);

    try {
      if (kDebugMode) {
        print('Adding multiple short services to: $url');
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
        successMessage = data['message'] ?? "Short services added successfully";
        if (kDebugMode) {
          print('Shared ref_id: ${data['data']?['shared_ref_id']}');
          print('Services count: ${data['data']?['services_count']}');
          print('Total payment: ${data['data']?['total_payment_amount']}');
        }
        await getAllShortServices(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to add short services";
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
    required String refId,
    String? clientName,
    String? userRefId,
    String? serviceCategoryName,
    int? quantity,
    double? unitPrice,
    double? discount,
    String? managerName,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_short_service.php");

    final Map<String, dynamic> requestBody = {
      "ref_id": refId,
    };

    // Add optional fields if provided
    if (clientName != null) requestBody["client_name"] = clientName;
    if (userRefId != null) requestBody["user_ref_id"] = userRefId;
    if (serviceCategoryName != null) requestBody["service_category_name"] = serviceCategoryName;
    if (quantity != null) requestBody["quantity"] = quantity;
    if (unitPrice != null) requestBody["unit_price"] = unitPrice;
    if (discount != null) requestBody["discount"] = discount;
    if (managerName != null) requestBody["manager_name"] = managerName;

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