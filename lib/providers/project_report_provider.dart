import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProjectReportProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/projects/projects";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  Map<String, dynamic>? reportData;

  /// Get project report
  Future<void> getProjectReport({required String projectRefId}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/project_report.php");

    final body = json.encode({"project_ref_id": projectRefId});

    try {
      if (kDebugMode) {
        print('Fetching project report from: $url');
        print('Request body: $body');
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        reportData = data['report'];
        successMessage = data['message'] ?? "Project report retrieved successfully";
        if (kDebugMode) {
          print('Project report fetched successfully');
        }
      } else {
        errorMessage = data['message'] ?? "Failed to fetch project report";
        if (kDebugMode) {
          print('API returned error: $errorMessage');
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

  /// Clear messages
  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  /// Clear report data
  void clearReportData() {
    reportData = null;
    notifyListeners();
  }
}

