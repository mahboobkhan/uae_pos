// providers/update_monthly_salary_provider.dart
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

class UpdateMonthlySalaryProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;

  /// Check internet
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Update Monthly Salary
  Future<void> updateMonthlySalary(UpdateMonthlySalaryRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    try {
      print("⏳ Sending update request for monthly salary...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/update_monthly_salary.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Raw Response: ${response.body}");
      final data = jsonDecode(response.body);
      final res = UpdateMonthlySalaryResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;
        print("✅ Monthly salary updated successfully");

        // Save locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("last_updated_salary", jsonEncode(request.toJson()));
        print("💾 Saved updated salary locally");
      } else {
        errorMessage = res.message;
        state = RequestState.error;
        print("⚠️ Update failed: ${res.message}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      print("❌ Exception: $e");
    }

    notifyListeners();
  }

  /// Get last updated salary
  Future<Map<String, dynamic>?> getLastUpdatedSalary() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("last_updated_salary");
    if (saved != null) {
      print("📌 Retrieved last updated salary");
      return jsonDecode(saved);
    }
    return null;
  }
}
// models/update_monthly_salary_response.dart
class UpdateMonthlySalaryResponse {
  final String status;
  final String message;

  UpdateMonthlySalaryResponse({
    required this.status,
    required this.message,
  });

  factory UpdateMonthlySalaryResponse.fromJson(Map<String, dynamic> json) {
    return UpdateMonthlySalaryResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
// models/update_monthly_salary_request.dart
class UpdateMonthlySalaryRequest {
  final String userId;
  final String salaryMonth;
  final double advanceSalary;
  final double bonus;
  final double fineDeduction;
  final String status;

  UpdateMonthlySalaryRequest({
    required this.userId,
    required this.salaryMonth,
    required this.advanceSalary,
    required this.bonus,
    required this.fineDeduction,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "salary_month": salaryMonth,
      "advance_salary": advanceSalary,
      "bonus": bonus,
      "fine_deduction": fineDeduction,
      "status": status,
    };
  }
}
