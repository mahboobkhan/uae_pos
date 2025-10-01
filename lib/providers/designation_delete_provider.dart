import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

/// ✅ Request State Enum
enum RequestState { idle, loading, success, error }

/// ✅ Request Model
class DesignationDeleteRequest {
  final String designations;

  DesignationDeleteRequest({required this.designations});

  Map<String, dynamic> toJson() {
    return {
      "designations": designations,
    };
  }
}

/// ✅ Response Model
class DesignationDeleteResponse {
  final String status;
  final String message;

  DesignationDeleteResponse({required this.status, required this.message});

  factory DesignationDeleteResponse.fromJson(Map<String, dynamic> json) {
    return DesignationDeleteResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

/// ✅ Provider Class
class DesignationDeleteProvider with ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;
  String? lastDeletedDesignation;

  /// Local saved designations list (simple for demo)
  List<String> designationList = ["Manager", "Employee", "Other"];

  /// ✅ Check Internet
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// ✅ Delete Designation API Call
  Future<void> deleteDesignation(DesignationDeleteRequest request) async {
    print("🟢 Step 1: Checking Internet...");
    if (!await _hasInternet()) {
      print("❌ No Internet Connection");
      state = RequestState.error;
      errorMessage = "No internet connection";
      notifyListeners();
      return;
    }
    print("✅ Internet available");

    try {
      state = RequestState.loading;
      notifyListeners();
      print("⏳ Step 2: Sending delete request → ${request.designations}");

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/delete_designation.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 Step 3: API Response → ${response.body}");

      final Map<String, dynamic> json = jsonDecode(response.body);
      final res = DesignationDeleteResponse.fromJson(json);

      if (res.status == "success") {
        print("✅ Step 4: Delete successful");
        lastDeletedDesignation = request.designations;

        /// Remove from local list
        designationList.remove(request.designations);
        print("🗑 Removed from local list: ${request.designations}");

        state = RequestState.success;
      } else {
        print("⚠️ Step 4: API Error → ${res.message}");
        state = RequestState.error;
        errorMessage = res.message;
      }
    } catch (e) {
      print("💥 Step 5: Exception → $e");
      state = RequestState.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// ✅ Get current designations
  List<String> getDesignations() {
    return designationList;
  }
}
