import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProjectsProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/projects/projects";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> projects = [];
  
  // Combined data for projects and short services
  List<Map<String, dynamic>> combinedData = [];
  Map<String, dynamic>? summaryData;
  
  // Filter parameters
  String? statusFilter;
  String? serviceCategoryIdFilter;
  String? userIdFilter;
  String? clientIdFilter;
  String? stageIdFilter;
  String? startDateFilter;
  String? endDateFilter;

  /// ✅ Get Combined Projects and Short Services
  Future<void> getCombinedProjectsAndShortServices() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Build query parameters for filtering
    final Map<String, String> queryParams = {};
    if (statusFilter != null && statusFilter!.isNotEmpty && statusFilter != 'All') {
      queryParams['status'] = statusFilter!;
    }
    if (serviceCategoryIdFilter != null && serviceCategoryIdFilter!.isNotEmpty && serviceCategoryIdFilter != 'All') {
      queryParams['service_category_id'] = serviceCategoryIdFilter!;
    }
    if (userIdFilter != null && userIdFilter!.isNotEmpty && userIdFilter != 'All') {
      queryParams['user_id'] = userIdFilter!;
    }
    if (clientIdFilter != null && clientIdFilter!.isNotEmpty && clientIdFilter != 'All') {
      queryParams['client_id'] = clientIdFilter!;
    }
    if (stageIdFilter != null && stageIdFilter!.isNotEmpty && stageIdFilter != 'All') {
      queryParams['stage_id'] = stageIdFilter!;
    }
    if (startDateFilter != null && startDateFilter!.isNotEmpty) {
      queryParams['start_date'] = startDateFilter!;
    }
    if (endDateFilter != null && endDateFilter!.isNotEmpty) {
      queryParams['end_date'] = endDateFilter!;
    }

    final url = Uri.parse("$baseUrl/get_all_project_and_short_services.php").replace(queryParameters: queryParams);

    try {
      if (kDebugMode) {
        print('Fetching combined data from: $url');
      }
      
      final response = await http.get(url);
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['data'] != null && data['data'] is List) {
            combinedData = List<Map<String, dynamic>>.from(data['data']);
            summaryData = data['summary'];
            successMessage = "Data fetched successfully";
            if (kDebugMode) {
              print('Fetched ${combinedData.length} items');
            }
          } else {
            combinedData = [];
            summaryData = null;
            errorMessage = "No data available";
            if (kDebugMode) {
              print('No data in response');
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

  /// ✅ Get All Projects
  Future<void> getAllProjects() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Build query parameters for filtering
    final Map<String, String> queryParams = {};
    if (statusFilter != null && statusFilter!.isNotEmpty && statusFilter != 'All') {
      queryParams['status'] = statusFilter!;
    }
    if (serviceCategoryIdFilter != null && serviceCategoryIdFilter!.isNotEmpty && serviceCategoryIdFilter != 'All') {
      queryParams['service_category_id'] = serviceCategoryIdFilter!;
    }
    if (userIdFilter != null && userIdFilter!.isNotEmpty && userIdFilter != 'All') {
      queryParams['user_id'] = userIdFilter!;
    }
    if (clientIdFilter != null && clientIdFilter!.isNotEmpty && clientIdFilter != 'All') {
      queryParams['client_id'] = clientIdFilter!;
    }
    if (stageIdFilter != null && stageIdFilter!.isNotEmpty && stageIdFilter != 'All') {
      queryParams['stage_id'] = stageIdFilter!;
    }
    if (startDateFilter != null && startDateFilter!.isNotEmpty) {
      queryParams['start_date'] = startDateFilter!;
    }
    if (endDateFilter != null && endDateFilter!.isNotEmpty) {
      queryParams['end_date'] = endDateFilter!;
    }

    final url = Uri.parse("$baseUrl/get_all_projects.php").replace(queryParameters: queryParams);

    try {
      if (kDebugMode) {
        print('Fetching projects from: $url');
      }
      
      final response = await http.get(url);
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['projects'] != null && data['projects'] is List && data['projects'].isNotEmpty) {
            projects = List<Map<String, dynamic>>.from(data['projects']);
            successMessage = "Projects fetched successfully";
            if (kDebugMode) {
              print('Fetched ${projects.length} projects');
            }
          } else {
            projects = [];
            errorMessage = "No projects available";
            if (kDebugMode) {
              print('No projects data in response');
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

  /// ✅ Add Project
  Future<void> addProject({
    String? clientId,
    String? orderType,
    String? serviceCategoryId,
    String? userId,
    String? status,
    String? stageId,
    String? quotation,
    String? pendingPayment,
    String? tags,
    String? dateTime,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_project.php");

    // Create body with only non-null values
    final Map<String, dynamic> bodyData = {};
    if (clientId != null && clientId.isNotEmpty) bodyData["client_id"] = clientId;
    if (orderType != null && orderType.isNotEmpty) bodyData["order_type"] = orderType;
    if (serviceCategoryId != null && serviceCategoryId.isNotEmpty) bodyData["service_category_id"] = serviceCategoryId;
    if (userId != null && userId.isNotEmpty) bodyData["user_id"] = userId;
    if (status != null && status.isNotEmpty) bodyData["status"] = status;
    if (stageId != null && stageId.isNotEmpty) bodyData["stage_id"] = stageId;
    if (quotation != null && quotation.isNotEmpty) bodyData["quotation"] = quotation;
    if (pendingPayment != null && pendingPayment.isNotEmpty) bodyData["pending_payment"] = pendingPayment;
    if (tags != null && tags.isNotEmpty) bodyData["tags"] = tags;

    final body = json.encode(bodyData);


    // try {
      if (kDebugMode) {
        print('Adding project to: $url');
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
        successMessage = data['message'] ?? "Project added successfully";
        await getAllProjects(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to add project";
      }
    // } catch (e) {
    //   errorMessage = "Network error: $e";
    //   if (kDebugMode) {
    //     print('Exception occurred: $e');
    //   }
    // }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Update Project
  Future<void> updateProject({
    required String projectRefId,
    String? clientId,
    String? orderType,
    String? serviceCategoryId,
    String? userId,
    String? status,
    String? stageId,
    String? quotation,
    String? pendingPayment,
    String? tags,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_project.php");

    // Create body with only non-null values
    final Map<String, dynamic> bodyData = {"project_ref_id": projectRefId};
    if (clientId != null && clientId.isNotEmpty) bodyData["client_id"] = clientId;
    if (orderType != null && orderType.isNotEmpty) bodyData["order_type"] = orderType;
    if (serviceCategoryId != null && serviceCategoryId.isNotEmpty) bodyData["service_category_id"] = serviceCategoryId;
    if (userId != null && userId.isNotEmpty) bodyData["user_id"] = userId;
    if (status != null && status.isNotEmpty) bodyData["status"] = status;
    if (stageId != null && stageId.isNotEmpty) bodyData["stage_id"] = stageId;
    if (quotation != null && quotation.isNotEmpty) bodyData["quotation"] = quotation;
    if (pendingPayment != null && pendingPayment.isNotEmpty) bodyData["pending_payment"] = pendingPayment;
    if (tags != null && tags.isNotEmpty) bodyData["tags"] = tags;
    bodyData["updated_at"] = DateTime.now().toIso8601String();

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Updating project at: $url');
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
        successMessage = data['message'] ?? "Project updated successfully";
        await getAllProjects(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to update project";
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

  /// ✅ Delete Project
  Future<void> deleteProject({required String projectRefId}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/delete_project.php");

    final body = json.encode({"project_ref_id": projectRefId});

    try {
      if (kDebugMode) {
        print('Deleting project at: $url');
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
        successMessage = data['message'] ?? "Project deleted successfully";
        await getAllProjects(); // Refresh list
      } else {
        errorMessage = data['message'] ?? "Failed to delete project";
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
    String? status,
    String? serviceCategoryId,
    String? userId,
    String? clientId,
    String? stageId,
    String? startDate,
    String? endDate,
  }) {
    statusFilter = status;
    serviceCategoryIdFilter = serviceCategoryId;
    userIdFilter = userId;
    clientIdFilter = clientId;
    stageIdFilter = stageId;
    startDateFilter = startDate;
    endDateFilter = endDate;
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    statusFilter = null;
    serviceCategoryIdFilter = null;
    userIdFilter = null;
    clientIdFilter = null;
    stageIdFilter = null;
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
}