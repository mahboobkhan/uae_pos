import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePinProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  UpdatePinResponse? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UpdatePinResponse? get response => _response;

  final String _url = 'https://abcwebservices.com/api/login/update_pin_or_password.php';

  Future<void> updatePin({
    required String userId,
    required String oldPin,
    required String newPin,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final body = jsonEncode({
        "user_id": userId,
        "type": "pin",
        "old": oldPin,
        "new": newPin,
      });

      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);
      
      // Check if API response is successful
      final isSuccess = response.statusCode == 200 && 
                       (data['status'] == 'success' || data['success'] == true);
      
      if (isSuccess) {
        // Parse response
        _response = UpdatePinResponse.fromJson(data);
        
        // ✅ Save the new PIN in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pin', newPin);
      } else {
        // Parse error response
        _response = UpdatePinResponse.fromJson(data);
        _errorMessage = _response?.message ?? 'Unknown error';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
class UpdatePinResponse {
  final bool success;
  final String message;

  UpdatePinResponse({required this.success, required this.message});

  factory UpdatePinResponse.fromJson(Map<String, dynamic> json) {
    // Check for both 'status' and 'success' fields
    final successValue = json['success'] ?? false;
    final statusValue = json['status'];
    
    return UpdatePinResponse(
      success: successValue || statusValue == 'success',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
