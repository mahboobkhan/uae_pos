import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum UpdatePasswordState { idle, loading, success, error }

class UpdatePasswordProvider with ChangeNotifier {
  UpdatePasswordState _state = UpdatePasswordState.idle;
  String? _errorMessage;
  UpdatePasswordResponse? _response;

  UpdatePasswordState get state => _state;

  String? get errorMessage => _errorMessage;

  UpdatePasswordResponse? get response => _response;

  Future<void> updatePassword(UpdatePasswordRequest request) async {
    print("🔹 Step 1: Starting password update process...");

    // Internet check
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print("❌ Step 2: No internet connection");
      _errorMessage = "No internet connection";
      _state = UpdatePasswordState.error;
      notifyListeners();
      return;
    }

    try {
      _state = UpdatePasswordState.loading;
      notifyListeners();
      print("⏳ Step 3: Sending request to server...");

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/login/update_password.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📩 Step 4: Received response with status ${response.statusCode}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _response = UpdatePasswordResponse.fromJson(data);
        _state = UpdatePasswordState.success;
        print("✅ Step 5: Password updated successfully");
      } else {
        _errorMessage = data["message"] ?? "Something went wrong";
        _state = UpdatePasswordState.error;
        print("⚠️ Step 5: Failed with error $_errorMessage");
      }
    } on SocketException {
      _errorMessage = "Unable to connect to server";
      _state = UpdatePasswordState.error;
      print("❌ Step 6: SocketException - No server connection");
    } catch (e) {
      _errorMessage = e.toString();
      _state = UpdatePasswordState.error;
      print("❌ Step 6: Exception occurred - $e");
    }

    notifyListeners();
  }
}

class UpdatePasswordRequest {
  final String userId;
  final String newPassword;

  UpdatePasswordRequest({required this.userId, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {"user_id": userId, "new_password": newPassword};
  }
}

class UpdatePasswordResponse {
  final String status;
  final String message;

  UpdatePasswordResponse({required this.status, required this.message});

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
