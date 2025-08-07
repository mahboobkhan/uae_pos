import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/request_state.dart';

class DesignationProvider with ChangeNotifier {
  String? selectedDesignation;

  RequestState state = RequestState.idle;
  String? errorMessage;
  List<DesignationRequest> _designations = [];

  List<DesignationRequest> get designations => _designations;

  /// ✅ Set & Save to SharedPreferences (only for dropdown change, no API call)
  Future<void> setDesignation(String value) async {
    selectedDesignation = value.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_designation', selectedDesignation!);
    print("💾 Saved designation locally: $selectedDesignation");
  }

  /// ✅ Load saved designation
  Future<void> loadDesignation() async {
    final prefs = await SharedPreferences.getInstance();
    selectedDesignation = prefs.getString('selected_designation');
    print("📥 Loaded saved designation: $selectedDesignation");
    notifyListeners();
  }

  String getDesignation() {
    return selectedDesignation ?? "";
  }

  /// ✅ Create designation role (API Call)
  Future<void> createDesignation(DesignationRequest request) async {
    print("🔄 Step 1: Checking Internet...");
    if (!await _hasInternet()) {
      state = RequestState.error;
      errorMessage = "No internet connection";
      notifyListeners();
      return;
    }

    print("✅ Internet available");

    try {
      // ✅ Reset state but don't clear errorMessage here
      state = RequestState.loading;
      errorMessage = null;
      notifyListeners();

      print("⏳ Step 2: Sending request to API...");

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/create_designation.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 Step 3: API response → ${response.body}");

      final Map<String, dynamic> json = jsonDecode(response.body);
      final res = DesignationResponse.fromJson(json);

      if (res.status.toLowerCase() == "success") {
        state = RequestState.success;
        errorMessage = null; // Keep success clean
      } else {
        state = RequestState.error;
        errorMessage = res.message; // Store exact API message
      }

    } catch (e) {
      print("💥 Step 5: Exception - $e");
      state = RequestState.error;
      errorMessage = "Unexpected error: $e";
    }

    notifyListeners();
  }

  /// ✅ Get all saved designations (local list)
  List<DesignationRequest> getAllDesignations() {
    print("📋 Getting all designations → count: ${_designations.length}");
    return _designations;
  }

  /// ✅ Internet check
  Future<bool> _hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}

// models/designation_request.dart
class DesignationRequest {
  final String userId;
  final String designations;
  final String createdBy;

  DesignationRequest({
    required this.userId,
    required this.designations,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "designations": designations,
      "created_by": createdBy,
    };
  }
}

// models/designation_response.dart
class DesignationResponse {
  final String status;
  final String message;

  DesignationResponse({required this.status, required this.message});

  factory DesignationResponse.fromJson(Map<String, dynamic> json) {
    return DesignationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
