import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProjectStageProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/projects/project_stages";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> projectStages = [];

  /// ✅ Get All Project Stages by Project Ref ID
  Future<void> getStagesByProject({required String projectRefId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/get_stages_by_project.php");

    try {
      if (kDebugMode) {
        print('Fetching project stages from: $url');
        print('Project Ref ID: $projectRefId');
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"project_ref_id": projectRefId}),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          if (data['data'] != null && data['data'] is List) {
            projectStages = List<Map<String, dynamic>>.from(data['data']);
            successMessage = "Project stages fetched successfully";
            if (kDebugMode) {
              print('Fetched ${projectStages.length} project stages');
            }
          } else {
            projectStages = [];
            errorMessage = "No project stages available";
            if (kDebugMode) {
              print('No project stages data in response');
            }
          }
        } else {
          errorMessage = data['message'] ?? "Failed to fetch project stages";
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

  /// ✅ Add Project Stage
  Future<void> addProjectStage({
    required String projectRefId,
    required String serviceDepartment,
    required List<String> applicationIds,
    required String stepCost,
    String? additionalProfit,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_project_stage.php");

    final Map<String, dynamic> bodyData = {
      "project_ref_id": projectRefId,
      "service_department": serviceDepartment,
      "application_ids": applicationIds,
      "step_cost": stepCost,
    };

    if (additionalProfit != null && additionalProfit.isNotEmpty) {
      bodyData["additional_profit"] = additionalProfit;
    }

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Adding project stage to: $url');
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

      if (data['success'] == true) {
        successMessage = data['message'] ?? "Project stage added successfully";
        // Refresh stages list
        await getStagesByProject(projectRefId: projectRefId);
      } else {
        errorMessage = data['message'] ?? "Failed to add project stage";
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

  /// ✅ Update Project Stage
  Future<void> updateProjectStage({
    required String projectStageRefId,
    String? endAt,
    String? stepCost,
    List<String>? applicationIds,
    String? additionalProfit,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_project_stage.php");

    final Map<String, dynamic> bodyData = {
      "project_stage_ref_id": projectStageRefId,
    };

    if (endAt != null && endAt.isNotEmpty) bodyData["end_at"] = endAt;
    if (stepCost != null && stepCost.isNotEmpty) bodyData["step_cost"] = stepCost;
    if (applicationIds != null && applicationIds.isNotEmpty) bodyData["application_ids"] = applicationIds;
    if (additionalProfit != null && additionalProfit.isNotEmpty) bodyData["additional_profit"] = additionalProfit;

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Updating project stage at: $url');
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

      if (data['success'] == true) {
        successMessage = data['message'] ?? "Project stage updated successfully";
        // Find the project_ref_id from current stages to refresh
        if (projectStages.isNotEmpty) {
          final projectRefId = projectStages.first['project_ref_id'];
          if (projectRefId != null) {
            await getStagesByProject(projectRefId: projectRefId);
          }
        }
      } else {
        errorMessage = data['message'] ?? "Failed to update project stage";
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

  /// ✅ Delete Project Stage
  Future<void> deleteProjectStage({required String projectStageRefId}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/delete_project_stage.php");

    final body = json.encode({"project_stage_ref_id": projectStageRefId});

    try {
      if (kDebugMode) {
        print('Deleting project stage at: $url');
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

      if (data['success'] == true) {
        successMessage = data['message'] ?? "Project stage deleted successfully";
        // Find the project_ref_id from current stages to refresh
        if (projectStages.isNotEmpty) {
          final projectRefId = projectStages.first['project_ref_id'];
          if (projectRefId != null) {
            await getStagesByProject(projectRefId: projectRefId);
          }
        }
      } else {
        errorMessage = data['message'] ?? "Failed to delete project stage";
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

  /// Get the last stage (for determining if buttons should be shown)
  Map<String, dynamic>? get lastStage {
    if (projectStages.isEmpty) return null;
    return projectStages.last;
  }

  /// Check if a stage is the last stage
  bool isLastStage(String projectStageRefId) {
    if (projectStages.isEmpty) return false;
    return projectStages.last['project_stage_ref_id'] == projectStageRefId;
  }

  /// Check if a stage is ended/closed
  bool isStageEnded(Map<String, dynamic> stage) {
    return stage['end_at'] != null;
  }

  /// Check if project is closed (all stages ended)
  bool isProjectClosed() {
    if (projectStages.isEmpty) return false;
    return projectStages.every((stage) => stage['end_at'] != null);
  }

  /// Check if all stages are ended
  bool areAllStagesEnded() {
    if (projectStages.isEmpty) return false;
    return projectStages.every((stage) => stage['end_at'] != null);
  }
}