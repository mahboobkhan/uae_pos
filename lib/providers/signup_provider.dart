import 'dart:convert';

import 'package:abc_consultant/ui/screens/SidebarLayout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/loading_dialog.dart';

class SignupProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? dob,
    String? gender,
    String? role,
    String? profilePic,
  }) async {
    final url = Uri.parse('https://abcwebservices.com/api/login/signup.php');
    final headers = {'Content-Type': 'application/json'};

    // Build request body dynamically with optional fields
    final Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "password": password,
    };

    if (phone != null) body["phone"] = phone;
    if (dob != null) body["dob"] = dob;
    if (gender != null) body["gender"] = gender;
    if (role != null) body["role"] = role;
    if (profilePic != null) body["profile_pic"] = profilePic;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      final jsonResponse = jsonDecode(response.body);

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
        return null; // success
      } else {
        return jsonResponse['message'] ?? "Signup failed";
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return "Network error: $e";
    }
  }

  // ------------------ LOGIN ------------------ //
  Future<bool> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://abcwebservices.com/api/login/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          return true;
        } else {
          error = jsonResponse['message'];
          return false;
        }
      } else {
        error = "Login failed: ${response.body}";
        return false;
      }
    } catch (e) {
      isLoading = false;
      error = "Error: $e";
      notifyListeners();
      return false;
    }
  }

  // -------- LOGIN HANDLER ------------------ //
  Future<void> handleLogin(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    showLoadingDialog(context);

    final success = await loginUser(context, email, password);

    hideLoadingDialog(context);

    if (success) {
      // next par move karny k lia ha ya
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SidebarLayout()),
      );
    } else {
      showError(context, error ?? "Login failed");
    }
  }

  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  Future<void> sendProjectToApi() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://abcwebservices.com/api/projects/projects.php'),
    );
    request.body = json.encode({
      "date_time": "2025-07-22 10:00:00",
      "client_search_type": "by_name",
      "order_type": "Urgent",
      "service_project": "Website Design",
      "assign_employee": "Hamza",
      "service_beneficiary": "Ali",
      "quote_price": 50000,
      "received_funds": 30000,
      "payment_id": "PAY123456",
      "status": "Pending",
      "tags": "Urgent,Priority",
      "stage": "Proposal Sent",
      "ref_id": "REF20250722001",
      "is_draft": 0,
    });
    request.headers.addAll(headers);
    try {
      // Send the request
      http.StreamedResponse response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print("✅ Success: $responseBody");
      } else {
        print("❌ Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❗ Exception occurred: $e");
    }
  }
}
