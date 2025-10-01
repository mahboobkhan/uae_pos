import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

/// ✅ Model for a single designation
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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "designations": designations,
      "created_by": createdBy,
      "created_date": createdDate,
    };
  }
}

/// ✅ Response model
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

/// ✅ Provider
class DesignationListProvider with ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;

  List<DesignationItem> _designations = [];
  List<DesignationItem> get designations => _designations;

  /// ✅ Check Internet
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// ✅ Fetch all designations
  Future<void> fetchDesignations() async {
    debugPrint("🌐 Checking internet...");
    if (!await _hasInternet()) {
      debugPrint("❌ No internet connection");
      state = RequestState.error;
      errorMessage = "No internet connection";
      notifyListeners();
      return;
    }

    try {
      state = RequestState.loading;
      notifyListeners();

      debugPrint("⏳ Sending request to get_all_designations.php...");
      final response = await http.get(
        Uri.parse("https://abcwebservices.com/api/employee/get_all_designations.php"),
      );

      debugPrint("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final res = DesignationListResponse.fromJson(jsonData);

        if (res.status == "success") {
          _designations = res.data;

          /// Save locally for offline use
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'saved_designations',
            jsonEncode(res.data.map((e) => e.toJson()).toList()),
          );

          debugPrint("💾 Saved ${res.data.length} designations locally");
          state = RequestState.success;
        } else {
          state = RequestState.error;
          errorMessage = res.status;
        }
      } else {
        state = RequestState.error;
        errorMessage = "HTTP ${response.statusCode}";
      }
    } catch (e) {
      debugPrint("💥 Exception: $e");
      state = RequestState.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// ✅ Load saved list from SharedPreferences (offline support)
  Future<void> loadSavedDesignations() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('saved_designations');

    if (savedData != null) {
      final List<dynamic> jsonList = jsonDecode(savedData);
      _designations = jsonList.map((e) => DesignationItem.fromJson(e)).toList();
      debugPrint("📦 Loaded ${_designations.length} saved designations");
      notifyListeners();
    }
  }
}
