import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class CreateMonthlySalaryProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;

  CreateMonthlySalaryProvider() {
    // Allow insecure/expired SSL for testing
    HttpOverrides.global = MyHttpOverrides();
  }

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> createMonthlySalary(CreateMonthlySalaryRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    try {
      print("🌍 Sending request to: https://abcwebservices.com/api/employee/create_monthly_salary.php");
      print("📦 Payload: ${jsonEncode(request.toJson())}");

      state = RequestState.loading;
      notifyListeners();

      final response = await http
          .post(
        Uri.parse("https://abcwebservices.com/api/employee/create_monthly_salary.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      )
          .timeout(const Duration(seconds: 15));

      print("📥 Response Code: ${response.statusCode}");
      print("📥 Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final res = CreateMonthlySalaryResponse.fromJson(data);

        if (res.status == "success") {
          state = RequestState.success;
          print("✅ Monthly salary created successfully");

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("last_created_salary", jsonEncode(request.toJson()));
          print("💾 Saved last created salary locally");
        } else {
          errorMessage = res.message;
          state = RequestState.error;
          print("⚠️ Creation failed: ${res.message}");
        }
      } else {
        errorMessage = "Server error: ${response.statusCode}";
        state = RequestState.error;
      }
    } on SocketException {
      errorMessage = "No internet or DNS lookup failed";
      state = RequestState.error;
      print("❌ SocketException: No internet or DNS issue");
    } on HandshakeException {
      errorMessage = "SSL handshake failed — check your certificate";
      state = RequestState.error;
      print("❌ HandshakeException: SSL issue");
    } on TimeoutException {
      errorMessage = "Request timed out";
      state = RequestState.error;
      print("❌ TimeoutException: Server took too long to respond");
    } catch (e) {
      errorMessage = "Unexpected error: $e";
      state = RequestState.error;
      print("❌ Unexpected Exception: $e");
    }

    notifyListeners();
  }

  Future<Map<String, dynamic>?> getLastCreatedSalary() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("last_created_salary");
    if (saved != null) {
      print("📌 Retrieved last created salary");
      return jsonDecode(saved);
    }
    return null;
  }
}

class CreateMonthlySalaryResponse {
  final String status;
  final String message;

  CreateMonthlySalaryResponse({
    required this.status,
    required this.message,
  });

  factory CreateMonthlySalaryResponse.fromJson(Map<String, dynamic> json) {
    return CreateMonthlySalaryResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}

class CreateMonthlySalaryRequest {
  final String userId;
  final String salaryMonth;
  final double advanceSalary;
  final double bonus;
  final double fineDeduction;
  final String status;

  CreateMonthlySalaryRequest({
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
