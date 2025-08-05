import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/request_state.dart';

class DesignationListProvider with ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;

  List<DesignationItem> _designations = [];
  List<DesignationItem> get designations => _designations;

  /// ✅ Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// ✅ Fetch designations list from API
  Future<void> fetchDesignations({String? userId}) async {
    print("🔄 Step 1: Checking internet...");
    if (!await _hasInternet()) {
      print("❌ No internet connection");
      state = RequestState.error;
      errorMessage = "No internet connection";
      notifyListeners();
      return;
    }
    print("✅ Internet available");

    try {
      state = RequestState.loading;
      notifyListeners();
      print("⏳ Step 2: Sending GET request...");

      final url = userId != null && userId.isNotEmpty
          ? "https://abcwebservices.com/api/employee/get_designations.php?user_id=$userId"
          : "https://abcwebservices.com/api/employee/get_designations.php";

      final response = await http.get(Uri.parse(url));

      print("📥 Step 3: API response received → ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final res = DesignationListResponse.fromJson(jsonData);

        if (res.status == "success") {
          print("✅ Step 4: Parsing and saving list...");
          _designations = res.data;

          /// Save locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('saved_designations', jsonEncode(res.data.map((e) => {
            "id": e.id,
            "user_id": e.userId,
            "designations": e.designations,
            "created_by": e.createdBy,
            "created_date": e.createdDate
          }).toList()));

          state = RequestState.success;
          print("💾 Step 5: Saved locally");
        } else {
          print("⚠️ API error → ${res.status}");
          state = RequestState.error;
          errorMessage = "Failed to load";
        }
      } else {
        print("⚠️ HTTP error code: ${response.statusCode}");
        state = RequestState.error;
        errorMessage = "HTTP ${response.statusCode}";
      }
    } catch (e) {
      print("💥 Exception → $e");
      state = RequestState.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// ✅ Load saved list from SharedPreferences
  Future<void> loadSavedDesignations() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('saved_designations');
    if (savedData != null) {
      final List<dynamic> jsonList = jsonDecode(savedData);
      _designations = jsonList.map((e) => DesignationItem.fromJson(e)).toList();
      print("📥 Loaded saved designations: ${_designations.length}");
      notifyListeners();
    }
  }
}
// models/designation_item.dart
class DesignationItem {
  final int id;
  final String userId;
  final String designations;
  final String createdBy;
  final String createdDate;

  DesignationItem({
    required this.id,
    required this.userId,
    required this.designations,
    required this.createdBy,
    required this.createdDate,
  });

  factory DesignationItem.fromJson(Map<String, dynamic> json) {
    return DesignationItem(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id']?.toString() ?? '',
      designations: json['designations'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdDate: json['created_date'] ?? '',
    );
  }
}

// models/designation_list_response.dart
class DesignationListResponse {
  final String status;
  final int count;
  final List<DesignationItem> data;

  DesignationListResponse({
    required this.status,
    required this.count,
    required this.data,
  });

  factory DesignationListResponse.fromJson(Map<String, dynamic> json) {
    return DesignationListResponse(
      status: json['status'] ?? '',
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => DesignationItem.fromJson(e))
          .toList(),
    );
  }
}
