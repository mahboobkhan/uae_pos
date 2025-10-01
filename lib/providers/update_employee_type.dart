import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

class EmployeeTypeUpdateProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;
  String? selectedEmployeeType;
  List<String> updatedTypesList = [];

  /// Set employee type from dropdown/textfield
  void setEmployeeType(String value) {
    selectedEmployeeType = value;
    print("✅ Selected Employee Type set: $value");
  }

  /// Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Update employee type API
  Future<void> updateEmployeeType(EmployeeTypeUpdateRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("saved_employee_type");

    print("📌 Previously saved: $saved");
    print("📌 New Employee Type: ${request.employeeType}");

    // Skip API if same value
    if (saved == request.employeeType) {
      print("⚠️ Same Employee Type → Skipping API call");
      state = RequestState.success;
      notifyListeners();
      return;
    }

    try {
      print("⏳ Sending update request to API...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/emp_type_api.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Raw Response: ${response.body}");
      final data = jsonDecode(response.body);

      final res = EmployeeTypeUpdateResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;
        await prefs.setString("saved_employee_type", request.employeeType);
        updatedTypesList.add(request.employeeType);
        print("💾 Saved locally: ${request.employeeType}");
      } else {
        errorMessage = res.message;
        state = RequestState.error;
        print("⚠️ API Error: ${res.message}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      print("❌ Exception: $e");
    }

    notifyListeners();
  }

  /// Get saved employee type
  Future<String?> getSavedEmployeeType() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("saved_employee_type");
    print("📌 Retrieved saved employee type: $saved");
    return saved;
  }

  /// Get all updated employee types (local list)
  List<String> getUpdatedTypesList() {
    return updatedTypesList;
  }
}
// models/employee_type_update_response.dart
class EmployeeTypeUpdateResponse {
  final String status;
  final String message;

  EmployeeTypeUpdateResponse({
    required this.status,
    required this.message,
  });

  factory EmployeeTypeUpdateResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeTypeUpdateResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
// models/employee_type_update_request.dart
class EmployeeTypeUpdateRequest {
  final String action;
  final int id;
  final String employeeType;

  EmployeeTypeUpdateRequest({
    this.action = "update",
    required this.id,
    required this.employeeType,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      "id": id,
      "employee_type": employeeType,
    };
  }
}
