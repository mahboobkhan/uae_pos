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

  static const _savedKey = "saved_employee_type";
  static const _listKey = "employee_type_list";

  /// Set employee type from dropdown/textfield
  void setEmployeeType(String value) {
    selectedEmployeeType = value;
    print("✅ Selected Employee Type set: $value");
    notifyListeners();
  }

  /// Check for internet
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Save new employee type to API and local storage
  Future<void> saveEmployeeType(EmployeeTypeRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedType = prefs.getString(_savedKey);
    print("📌 Previously saved: $savedType");
    print("📌 New Employee Type: ${request.employeeType}");

    // If same, skip
    if (savedType == request.employeeType) {
      print("⚠️ Same employee type, skipping");
      state = RequestState.success;
      notifyListeners();
      return;
    }

    try {
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/emp_type_api.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Response: ${response.body}");
      final jsonData = jsonDecode(response.body);
      final res = EmployeeTypeResponse.fromJson(jsonData);

      if (res.status == "success") {
        state = RequestState.success;
        await prefs.setString(_savedKey, request.employeeType);

        // Save to list and persist
        if (!employeeTypeList.contains(request.employeeType)) {
          employeeTypeList.add(request.employeeType);
          await prefs.setStringList(_listKey, employeeTypeList);
        }

        print("✅ Employee type saved: ${request.employeeType}");
      } else {
        errorMessage = res.message;
        state = RequestState.error;
        print("❌ Error: ${res.message}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      print("❌ Exception: $e");
    }

    notifyListeners();
  }

  /// Load all employee types from local storage
  Future<void> loadEmployeeTypes() async {
    final prefs = await SharedPreferences.getInstance();
    employeeTypeList = prefs.getStringList(_listKey) ?? [];
    print("📄 Loaded employee types: $employeeTypeList");
    notifyListeners();
  }

  /// Get last saved employee type
  Future<String?> getSavedEmployeeType() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_savedKey);
    print("📌 Last selected employee type: $saved");
    return saved;
  }

  /// Clear all stored types (optional helper)
  Future<void> clearEmployeeTypes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_listKey);
    await prefs.remove(_savedKey);
    employeeTypeList.clear();
    print("🧹 Cleared all saved employee types");
    notifyListeners();
  }

  /// Get all current employee types
  List<String> getAllEmployeeTypes() => employeeTypeList;
}
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
