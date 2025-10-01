import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ServiceCategoryProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/projects/service_categorios";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> serviceCategories = [];

  /// ✅ Get Service Categories
  Future<void> getServiceCategories() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/get_service_categories.php");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['data'] != null && data['data'] is List && data['data'].isNotEmpty) {
            serviceCategories = List<Map<String, dynamic>>.from(data['data']);
            successMessage = "Service categories fetched successfully";
          } else {
            serviceCategories = [];
            errorMessage = "No service categories available";
          }          successMessage = "Data fetched successfully";
        } else {
          errorMessage = data['message'] ?? "Failed to fetch data";
        }
      } else {
        errorMessage = "Error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Add Service Category
  Future<void> addServiceCategory({
    required String serviceName,
    required String quotation,
    String? serviceProviderName,
    String? date,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_service_category.php");

    final body = json.encode({
      "service_name": serviceName,
      "quotation": quotation,
      "service_provider_name": serviceProviderName ?? "",
      "date": date ?? "",
    });

    try {
      final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Category added successfully";
        await getServiceCategories(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to add category";
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Update Service Category
  Future<void> updateServiceCategory({
    required String refId,
    required String serviceName,
    required String quotation,
    String? serviceProviderName,
    String? date,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_service_category.php");

    final body = json.encode({
      "ref_id": refId,
      "service_name": serviceName,
      "quotation": quotation,
      "service_provider_name": serviceProviderName ?? "",
      "date": date ?? "",
    });

    try {
      final response = await http.put(url, headers: {"Content-Type": "application/json"}, body: body);
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Category updated successfully";
        await getServiceCategories();
      } else {
        errorMessage = data['message'] ?? "Failed to update category";
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Delete Service Category
  Future<void> deleteServiceCategory({required String refId}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/delete_service_category.php");

    final body = json.encode({"ref_id": refId});

    try {
      final response = await http.delete(url, headers: {"Content-Type": "application/json"}, body: body);
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        successMessage = data['message'] ?? "Category deleted successfully";
        await getServiceCategories();
      } else {
        errorMessage = data['message'] ?? "Failed to delete category";
      }
    } catch (e) {
      errorMessage = e.toString();
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
