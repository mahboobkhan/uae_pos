import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/screens/SidebarLayout.dart';
import '../ui/screens/login screens/forgot_screen.dart';
import '../ui/screens/login screens/verification_screen.dart';
import '../widgets/loading_dialog.dart';

extension _AccessNormalize on Map<String, dynamic> {
  Map<String, int> toZeroOne() {
    int asBit(dynamic v) {
      if (v == null) return 0;
      if (v is bool) return v ? 1 : 0;
      if (v is num) return v == 0 ? 0 : 1;
      final s = v.toString().trim().toLowerCase();
      return (s == '1' || s == 'true' || s == 'yes') ? 1 : 0;
    }

    return map((k, v) => MapEntry(k, asBit(v)));
  }
}

class SignupProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;

  List<Map<String, dynamic>> _users = [];

  List<Map<String, dynamic>> get users => _users;

  Map<String, bool> _accessMap = {};

  Map<String, bool> get accessMap => _accessMap;

  /// ============================
  /// Employee Management
  /// ============================
  List<Map<String, dynamic>> _employees = [];

  List<Map<String, dynamic>> get employees => _employees;

  /// Fetch employees from API
  Future<void> fetchEmployees() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://abcwebservices.com/api/employee/get_employees.php'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success' && responseData['data'] is List) {
          _employees = List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          _employees = [];
        }
      } else {
        _employees = [];
      }
    } catch (e) {
      _employees = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new employee
  Future<Map<String, dynamic>> createEmployeeProfile(Map<String, dynamic> profileData) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://abcwebservices.com/api/employee/create_profile.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profileData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 'exists') {
          return {'success': false, 'status': 'exists', 'message': 'Profile already exists'};
        } else if (responseData['status'] == 'submitted') {
          _employees.add(responseData['data']);
          notifyListeners();
          return {
            'success': true,
            'status': 'submitted',
            'message': 'Profile created successfully',
            'data': responseData['data'],
          };
        }
      }

      return {'success': false, 'message': responseData['message'] ?? 'Failed to create profile'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Update employee profile
  Future<Map<String, dynamic>> updateEmployeeProfile(Map<String, dynamic> updateData) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://abcwebservices.com/api/employee/update_profile.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updateData),
      );
      print("Payload2: $updateData");
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 'error') {
          return {'success': false, 'status': 'error', 'message': responseData['message'] ?? 'Profile not found'};
        } else if (responseData['status'] == 'updated') {
          final index = _employees.indexWhere((emp) => emp['id'] == responseData['data']['id']);
          if (index != -1) {
            _employees[index] = {..._employees[index], ...responseData['data']};
            notifyListeners();
          }
          return {
            'success': true,
            'status': 'updated',
            'message': 'Profile updated successfully',
            'data': responseData['data'],
          };
        }
      }

      return {'success': false, 'message': responseData['message'] ?? 'Failed to update profile'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ////////////
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

    final Map<String, dynamic> body = {"name": name, "email": email, "password": password};

    if (phone != null) body["phone"] = phone;
    if (dob != null) body["dob"] = dob;
    if (gender != null) body["gender"] = gender;
    if (role != null) body["role"] = role;
    if (profilePic != null) body["profile_pic"] = profilePic;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await http.post(url, headers: headers, body: jsonEncode(body));
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
        return {"error": jsonResponse['message'] ?? "Signup failed"};
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return {"error": "Network error: $e"};
    }
  }

  ////////////

  Future<String?> resendVerificationPin({
    required String userId,
    required String to, // 'user', 'admin', or 'both'
  }) async {
    final url = Uri.parse('https://abcwebservices.com/api/login/resend_verification.php');
    final headers = {'Content-Type': 'application/json'};

    final Map<String, dynamic> body = {"user_id": userId, "to": to};

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await http.post(url, headers: headers, body: jsonEncode(body));

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

  //////////
  Future<String?> verifyUser({required String userId, required String pinUser, required String pinAdmin}) async {
    print("Sending for : $userId");
    final url = Uri.parse('https://abcwebservices.com/api/login/verify_user.php');
    final headers = {'Content-Type': 'application/json'};

    final Map<String, dynamic> body = {"user_id": userId, "pin_user": pinUser, "pin_admin": pinAdmin};

    print('userID : $userId');
    print('userID : pin  $pinUser');
    print('userID :admin $pinAdmin');

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await http.post(url, headers: headers, body: jsonEncode(body));

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

  /////////

  Future<void> fetchAllUsersWithAccess() async {
    final url = Uri.parse('https://abcwebservices.com/api/login/get_all_users_with_access.php');

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(url, headers: {'Accept': 'application/json'});

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
      print("📥 Response (${response.statusCode}): ${response.body}");
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
    final url = Uri.parse('https://abcwebservices.com/api/login/update_access.php');

    // Build payload exactly as the PHP expects
    final payload = <String, dynamic>{
      'user_id': userId,
      'access': accessData.toZeroOne(), // <-- nested + normalized to 0/1
    };

    try {
      final response = await http
          .post(
            url,
            headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 20));

      // Try to parse JSON; if server sends HTML on errors, guard it
      Map<String, dynamic>? result;
      try {
        result = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {}

      if (response.statusCode == 200 && result != null && result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Access updated successfully')));
        return true;
      } else {
        final msg = result?['message'] ?? 'Update failed (HTTP ${response.statusCode})';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network error: $e')));
      return false;
    }
  }

  ////////
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

  //////// login provider
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

        final user = jsonResponse['user'] ?? {};
        final isAdmin = jsonResponse['is_admin'] ?? {};
        final access = jsonResponse['access'] ?? {};
        print('loginwork 200 ${isAdmin}');

        // ✅ Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user['user_id'] ?? '');
        await prefs.setString('name', user['name'] ?? '');
        await prefs.setString('email', user['email'] ?? '');
        await prefs.setString('password', password);
        await prefs.setBool('verification', user['verification'] ?? '');
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
            MaterialPageRoute(
              builder: (context) => VerificationScreen(userId: user['user_id'], email: user['email'], adminEmail: ""),
            ),
          );
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SidebarLayout()));
        }
      } else {
        print('loginwork status error ${jsonResponse['message']} ');

        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Login Failed"),
                content: Text(jsonResponse['message']),
                actions: [TextButton(child: const Text("OK"), onPressed: () => Navigator.of(context).pop())],
              ),
        );
        ;
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text("Error", style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
    );
  }

  ///////
  Future<String?> updatePassword({required String userId, required String newPassword}) async {
    final url = Uri.parse('https://abcwebservices.com/api/login/update_password.php');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({"user_id": userId, "new_password": newPassword});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          return null; // success
        } else {
          return data['message'] ?? 'Failed to update password';
        }
      } else {
        return 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  //////////
  /// Logout and clear all stored data
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
  }

  //////////
  Future<void> sendForgetPasswordRequest(BuildContext context, String email) async {
    if (email.isEmpty) {
      _showErrorDialog(context, "Please enter your email.");
      return;
    }

    final url = Uri.parse('https://abcwebservices.com/api/login/forget_pass.php');

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );
      Navigator.of(context).pop(); // Close loading dialog

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final userId = data['data']['user_id'];
        final emailResponse = data['data']['email'];
        final adminEmail = data['data']['admin_email'];

        // Navigate to Forgot Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotScreen(userId: userId, email: emailResponse, adminEmail: adminEmail),
          ),
        );
      } else {
        _showErrorDialog(context, data['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading
      _showErrorDialog(context, "Failed to connect to the server.");
    }

    // ... existing code
  }

  // create tags function
  Future<String> createTag({required String userId, required String tagName, required String createdBy}) async {
    try {
      final url = Uri.parse('https://abcwebservices.com/api/employee/create_tag.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'tag_name': tagName, 'created_by_user': createdBy}),
      );

      final data = jsonDecode(response.body);
      return data['status']; // "success", "exists", or "error"
    } catch (e) {
      debugPrint("Error creating tag: $e");
      return 'error';
    }
  }

  // tags update
  Future<String> updateTag({required String userId, required String oldTagName, required String newTagName}) async {
    try {
      final url = Uri.parse('https://abcwebservices.com/api/employee/update_tag.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'old_tag_name': oldTagName, 'new_tag_name': newTagName}),
      );

      final data = jsonDecode(response.body);
      return data['status']; // "success", "exists", or "error"
    } catch (e) {
      debugPrint("Tag update error: $e");
      return 'error';
    }
  }

  /// tag delete
  Future<String> deleteTag({required String userId, required String tagName}) async {
    try {
      final url = Uri.parse('https://abcwebservices.com/api/employee/delete_tag.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'tag_name': tagName}),
      );

      final data = jsonDecode(response.body);
      return data['status']; // "success" or "failed"
    } catch (e) {
      debugPrint("Tag deletion error: $e");
      return 'error';
    }
  }

  /// get all tags
  Future<List<Map<String, dynamic>>> getAllTags(String userId) async {
    final url = Uri.parse("https://abcwebservices.com/api/employee/get_all_tags.php");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          // Filter only current user's tags
          final List<Map<String, dynamic>> userTags =
              (data['tags'] as List)
                  .where((tag) => tag['user_id'] == userId)
                  .map(
                    (tag) => {
                      'id': tag['id'],
                      'tag': tag['tag_name'], // Standardizing name for UI
                    },
                  )
                  .toList();

          return userTags;
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to load tags");
      }
    } catch (e) {
      debugPrint("Error fetching tags: $e");
      return [];
    }
  }

  /// desigination

  Future<String> createDesignation({
    required String userId,
    required String designation,
    required String createdBy,
  }) async {
    const String url = 'https://abcwebservices.com/api/employee/create_designation.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'designations': designation, 'created_by': createdBy}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 'success') {
          return 'success'; // Designation created
        } else if (data['status'] == 'exists') {
          return 'exists'; // Already exists
        } else {
          return 'error'; // Unknown response
        }
      } else {
        return 'server_error';
      }
    } catch (e) {
      return 'exception'; // Network or JSON error
    }
  }
}

// error dialog
void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text("Error", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK", style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
  );
}
