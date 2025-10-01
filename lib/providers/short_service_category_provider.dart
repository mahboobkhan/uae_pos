import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ShortServiceCategoryProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/projects/short_services_categories";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> categories = [];

  /// ✅ Get All Short Service Categories
  Future<void> getAllShortServiceCategories() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/get_short_service_categories.php");

    try {
      if (kDebugMode) {
        print('Fetching short service categories from: $url');
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
            categories = List<Map<String, dynamic>>.from(data['data']);
            successMessage = "Categories fetched successfully";
            if (kDebugMode) {
              print('Fetched ${categories.length} categories');
            }
          } else {
            categories = [];
            errorMessage = "No categories available";
            if (kDebugMode) {
              print('No categories data in response');
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

  /// ✅ Add Short Service Category
  Future<void> addShortServiceCategory({
    required String categoryName,
    required String description,
    String status = "active",
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_short_service_category.php");

    final body = json.encode({
      "category_name": categoryName,
      "description": description,
      "status": status,
    });

    try {
      if (kDebugMode) {
        print('Adding short service category to: $url');
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
        successMessage = data['message'] ?? "Category added successfully";
        await getAllShortServiceCategories(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to add category";
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