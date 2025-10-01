import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BankingPaymentMethodProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/banking/add_payment_method";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> paymentMethods = [];
  
  // Filter parameters
  String? bankNameFilter;
  String? accountTitleFilter;
  String? statusFilter;
  String? tagsFilter;
  String? startDateFilter;
  String? endDateFilter;

  /// ✅ Get All Payment Methods
  Future<void> getAllPaymentMethods() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/get_all_payment_methods.php");

    try {
      if (kDebugMode) {
        print('Fetching payment methods from: $url');
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
            paymentMethods = List<Map<String, dynamic>>.from(data['data']);
            successMessage = "Payment methods fetched successfully";
            if (kDebugMode) {
              print('Fetched ${paymentMethods.length} payment methods');
            }
          } else {
            paymentMethods = [];
            errorMessage = "No payment methods available";
            if (kDebugMode) {
              print('No payment methods data in response');
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

  /// ✅ Add Payment Method
  Future<void> addPaymentMethod({
    required String userId,
    required String bankName,
    required String accountTitle,
    required String accountNum,
    required String iban,
    required String registeredPhone,
    required String registeredEmail,
    required String bankAddress,
    List<String>? tags,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_payment_method.php");

    final Map<String, dynamic> bodyData = {
      "user_id": userId,
      "bank_name": bankName,
      "account_title": accountTitle,
      "account_num": accountNum,
      "iban": iban,
      "registered_phone": registeredPhone,
      "registered_email": registeredEmail,
      "bank_address": bankAddress,
    };

    if (tags != null && tags.isNotEmpty) {
      bodyData["tags"] = tags;
    }

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Adding payment method to: $url');
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
        successMessage = data['message'] ?? "Payment method added successfully";
        await getAllPaymentMethods(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to add payment method";
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

  /// ✅ Update Payment Method
  Future<void> updatePaymentMethod({
    required String paymentMethodRefId,
    String? bankName,
    String? accountTitle,
    String? accountNum,
    String? iban,
    String? registeredPhone,
    String? registeredEmail,
    String? bankAddress,
    List<String>? tags,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_payment_method.php");

    // Create body with only non-null values
    final Map<String, dynamic> bodyData = {"payment_method_ref_id": paymentMethodRefId};
    if (bankName != null && bankName.isNotEmpty) bodyData["bank_name"] = bankName;
    if (accountTitle != null && accountTitle.isNotEmpty) bodyData["account_title"] = accountTitle;
    if (accountNum != null && accountNum.isNotEmpty) bodyData["account_num"] = accountNum;
    if (iban != null && iban.isNotEmpty) bodyData["iban"] = iban;
    if (registeredPhone != null && registeredPhone.isNotEmpty) bodyData["registered_phone"] = registeredPhone;
    if (registeredEmail != null && registeredEmail.isNotEmpty) bodyData["registered_email"] = registeredEmail;
    if (bankAddress != null && bankAddress.isNotEmpty) bodyData["bank_address"] = bankAddress;
    if (tags != null && tags.isNotEmpty) bodyData["tags"] = tags;

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Updating payment method at: $url');
        print('Request body: $body');
      }
      
      final response = await http.put(
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
        successMessage = data['message'] ?? "Payment method updated successfully";
        await getAllPaymentMethods(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to update payment method";
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

  /// ✅ Delete Payment Method
  Future<void> deletePaymentMethod({required String paymentMethodRefId}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/delete_payment_method.php");

    final body = json.encode({"payment_method_ref_id": paymentMethodRefId});

    try {
      if (kDebugMode) {
        print('Deleting payment method at: $url');
        print('Request body: $body');
      }
      
      final response = await http.delete(
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
        successMessage = data['message'] ?? "Payment method deleted successfully";
        await getAllPaymentMethods(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to delete payment method";
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

  /// Set filters
  void setFilters({
    String? bankName,
    String? accountTitle,
    String? status,
    String? tags,
    String? startDate,
    String? endDate,
  }) {
    bankNameFilter = bankName;
    accountTitleFilter = accountTitle;
    statusFilter = status;
    tagsFilter = tags;
    startDateFilter = startDate;
    endDateFilter = endDate;
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    bankNameFilter = null;
    accountTitleFilter = null;
    statusFilter = null;
    tagsFilter = null;
    startDateFilter = null;
    endDateFilter = null;
    notifyListeners();
  }

  /// Clear messages
  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  /// Get filtered payment methods
  List<Map<String, dynamic>> get filteredPaymentMethods {
    List<Map<String, dynamic>> filtered = List.from(paymentMethods);

    if (bankNameFilter != null && bankNameFilter!.isNotEmpty) {
      filtered = filtered.where((pm) => 
        pm['bank_name']?.toString().toLowerCase().contains(bankNameFilter!.toLowerCase()) ?? false
      ).toList();
    }

    if (accountTitleFilter != null && accountTitleFilter!.isNotEmpty) {
      filtered = filtered.where((pm) => 
        pm['account_title']?.toString().toLowerCase().contains(accountTitleFilter!.toLowerCase()) ?? false
      ).toList();
    }

    if (tagsFilter != null && tagsFilter!.isNotEmpty) {
      filtered = filtered.where((pm) {
        final tags = pm['tags'];
        if (tags is List) {
          return tags.any((tag) => tag.toString().toLowerCase().contains(tagsFilter!.toLowerCase()));
        }
        return false;
      }).toList();
    }

    return filtered;
  }
}