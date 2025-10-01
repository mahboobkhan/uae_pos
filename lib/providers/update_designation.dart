import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

class DesignationUpdateProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;

  /// ✅ Check Internet Connection
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// ✅ Update designation by ID
  Future<void> updateDesignation(int id, String newDesignation) async {
    debugPrint("🔍 Starting update: id=$id → $newDesignation");

    // 1️⃣ Internet Check
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      debugPrint("❌ No internet connection");
      return;
    }

    try {
      // 2️⃣ Set loading state
      state = RequestState.loading;
      notifyListeners();
      debugPrint("⏳ Sending update request to server...");

      // 3️⃣ Send POST request
      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/update_designation.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "new_designations": newDesignation,
        }),
      );

      debugPrint("📥 API Response: ${response.body}");

      // 4️⃣ Parse response
      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        state = RequestState.success;

        // Save locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("last_updated_designation", newDesignation);

        debugPrint("✅ Updated successfully & saved locally");
      } else {
        errorMessage = data["message"];
        state = RequestState.error;
        debugPrint("⚠️ Update failed: ${data["message"]}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      debugPrint("💥 Exception during update: $e");
    }

    // 5️⃣ Notify listeners
    notifyListeners();
  }

  /// ✅ Get last updated designation from local storage
  Future<String?> getLastUpdatedDesignation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("last_updated_designation");
  }
}
