import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

class EmployeeTypeProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;
  String? selectedEmployeeType;
  List<String> employeeTypeList = [];

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

  /// Save employee type
  Future<void> saveEmployeeType(EmployeeTypeRequest request) async {
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

    // Skip if same
    if (saved == request.employeeType) {
      print("⚠️ Same Employee Type found → Skipping API call");
      state = RequestState.success;
      notifyListeners();
      return;
    }

    try {
      print("⏳ Sending request to create Employee Type...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/emp_type_api.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Raw Response: ${response.body}");
      final data = jsonDecode(response.body);

      final res = EmployeeTypeResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;
        await prefs.setString("saved_employee_type", request.employeeType);
        employeeTypeList.add(request.employeeType);
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

  /// Get all locally stored types
  List<String> getAllEmployeeTypes() {
    return employeeTypeList;
  }
}
// models/employee_type_response.dart
class EmployeeTypeResponse {
  final String status;
  final String message;

  EmployeeTypeResponse({
    required this.status,
    required this.message,
  });

  factory EmployeeTypeResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeTypeResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
// models/employee_type_request.dart
class EmployeeTypeRequest {
  final String action;
  final String userId;
  final String employeeType;
  final String createdBy;

  EmployeeTypeRequest({
    this.action = "create",
    required this.userId,
    required this.employeeType,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      "user_id": userId,
      "employee_type": employeeType,
      "created_by": createdBy,
    };
  }
}
