import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupProvider with ChangeNotifier {
  bool isLoading = false;

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('https://abcwebservices.com/login/signup.php');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "name": name,
      "email": email,
      "phone": "null",
      "password": password,
    });

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(url, headers: headers, body: body);
      final jsonResponse = jsonDecode(response.body);

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
        return null; // null means success
      } else {
        return jsonResponse['message'] ?? "Signup failed";
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return "Network error: $e";
    }
  }
}
