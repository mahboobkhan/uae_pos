import 'dart:convert';

import 'package:abc_consultant/ui/screens/SidebarLayout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/screens/login screens/verification_screen.dart';
import '../widgets/loading_dialog.dart';

class SignupProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;

  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> get users => _users;

  Map<String, bool> _accessMap = {};
  Map<String, bool> get accessMap => _accessMap;



  Future<Map<String, dynamic>?> registerUser({
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
        return {
          "user_id": jsonResponse['data']['user_id'],
          "email": jsonResponse['data']['email'],
          "admin_email": jsonResponse['data']['admin_email'],
        };
      } else {
        return {
          "error": jsonResponse['message'] ?? "Signup failed"
        };
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return {
        "error": "Network error: $e"
      };
    }
  }


  Future<String?> resendVerificationPin({
    required String userId,
    required String to, // 'user', 'admin', or 'both'
  }) async {
    final url = Uri.parse(
        'https://abcwebservices.com/api/login/resend_verification.php');
    final headers = {'Content-Type': 'application/json'};

    final Map<String, dynamic> body = {
      "user_id": userId,
      "to": to,
    };

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
        return null; // Success
      } else {
        return jsonResponse['message'] ?? "Failed to resend PIN";
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return "Network error: $e";
    }
  }


  Future<String?> verifyUser({
    required String userId,
    required String pinUser,
    required String pinAdmin,
  }) async {
    final url = Uri.parse(
        'https://abcwebservices.com/api/login/verify_user.php');
    final headers = {'Content-Type': 'application/json'};

    final Map<String, dynamic> body = {
      "user_id": userId,
      "pin_user": pinUser,
      "pin_admin": pinAdmin,
    };

    print('userID : $userId');
    print('userID : pin  $pinUser');
    print('userID :admin $pinAdmin');

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
        return null; // Verification success
      } else {
        return jsonResponse['message'] ?? "Verification failed";
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return "Network error: $e";
    }
  }

  Future<void> fetchAllUsersWithAccess() async {
    final url = Uri.parse(
        'https://abcwebservices.com/api/login/get_all_users_with_access.php');

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          _users = List<Map<String, dynamic>>.from(data['data']);
          print('new data: ${jsonEncode(data['data'])}');
        } else {
          print('new data error' + data['message']);
          throw Exception(data['message'] ?? 'Failed to fetch users');
        }
      } else {
        print('new data error' + response.statusCode.toString());
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  /// Update user access
  Future<bool> updateUserAccess({
    required String userId,
    required Map<String, dynamic> accessData,
    required BuildContext context,
  }) async {
    final url = Uri.parse(
        'https://abcwebservices.com/api/login/update_access.php');

    try {
      final body = {
        'user_id': userId,
        ...accessData, // Merge access permissions into request
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access updated successfully')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Update failed')),
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error updating access: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }

  Future<void> fetchUserAccess(String userId) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://abcwebservices.com/api/login/get_access.php?user_id=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          final accessData = Map<String, dynamic>.from(data['access']);
          accessData.remove('id');
          accessData.remove('user_id');
          accessData.remove('updated_at');

          _accessMap = accessData.map((key, value) => MapEntry(key, value == 1));
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch access: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching access: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool getAccess(String key) {
    return _accessMap[key] ?? false;
  }






  Future<void> handleLogin(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      ) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    showLoadingDialog(context);
    print('loginwork start');

    final response = await http.post(
      Uri.parse('https://abcwebservices.com/api/login/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    hideLoadingDialog(context);

    if (response.statusCode == 200) {
      print('loginwork 200 result');

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {

        print('loginwork status success');


        final user = jsonResponse['user'];
        final access = jsonResponse['access'];

        // ✅ Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user['user_id']);
        await prefs.setString('name', user['name']);
        await prefs.setString('email', user['email']);
        await prefs.setString('password', user['password']);
        await prefs.setBool('verification', user['verification']);
        await prefs.setString('created_at', user['created_at'] ?? '');
        await prefs.setString('pin', user['pin'] ?? '');
        await prefs.setString('login_time', user['login_time'] ?? '');

        // Save all access permissions (optional)
        await prefs.setString('access', jsonEncode(access));

        print('loginwork access ${jsonEncode(access)}');


        // ✅ Navigate based on verification status
        if (user['verification'] == false) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VerificationScreen(userId: user['user_id'],email: user['email'],adminEmail: "",)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SidebarLayout()),
          );
        }
      } else {

        print('loginwork status error ${jsonResponse['message']} ');

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Login Failed"),
            content: Text(jsonResponse['message']),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );;
      }
    } else {
      showError(context, 'Server error: ${response.statusCode}');
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

/*
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
*/
}
