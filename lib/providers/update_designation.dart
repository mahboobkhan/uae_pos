import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

/// Model for designation item
class DesignationItem {
  final int id;
  final String name;

  DesignationItem({required this.id, required this.name});

  factory DesignationItem.fromJson(Map<String, dynamic> json) {
    return DesignationItem(
      id: json['id'] ?? 0,
      name: json['designations'] ?? '',
    );
  }
}

/// Request model for update
class DesignationUpdateRequest {
  final int id;
  final String newDesignations;

  DesignationUpdateRequest({
    required this.id,
    required this.newDesignations,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "new_designations": newDesignations,
    };
  }
}

/// Response model for update
class DesignationUpdateResponse {
  final String status;
  final String message;

  DesignationUpdateResponse({
    required this.status,
    required this.message,
  });

  factory DesignationUpdateResponse.fromJson(Map<String, dynamic> json) {
    return DesignationUpdateResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class DesignationUpdateProvider with ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;
  String? lastUpdatedDesignation;

  /// Saved designation list from API
  List<DesignationItem> designationList = [];

  /// Local history of updates
  final List<String> _updatedDesignations = [];
  List<String> get updatedDesignations => _updatedDesignations;

  /// ✅ Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// ✅ Fetch designation list from API
  Future<void> fetchDesignations() async {
    print("🔄 Fetching designations list...");
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      print("❌ No internet connection");
      notifyListeners();
      return;
    }

    try {
      state = RequestState.loading;
      notifyListeners();

      final response = await http.get(
        Uri.parse("https://abcwebservices.com/api/employee/get_designations.php"),
      );

      print("📥 API Response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        designationList =
            jsonList.map((e) => DesignationItem.fromJson(e)).toList();
        print("✅ Designations loaded: ${designationList.length}");
        state = RequestState.success;
      } else {
        errorMessage = "Failed to load designations";
        state = RequestState.error;
      }
    } catch (e) {
      print("💥 Error fetching designations: $e");
      errorMessage = e.toString();
      state = RequestState.error;
    }

    notifyListeners();
  }

  /// ✅ Update designation API
  Future<void> updateDesignation(DesignationUpdateRequest request) async {
    print("🔄 Step 1: Checking Internet...");
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
      print("⏳ Step 2: Sending update request to API...");

      final response = await http.post(
        Uri.parse(
            "https://abcwebservices.com/api/employee/update_designation.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 Step 3: API response received → ${response.body}");

      final Map<String, dynamic> json = jsonDecode(response.body);
      final res = DesignationUpdateResponse.fromJson(json);

      if (res.status == "success") {
        print("✅ Step 4: Update successful");
        lastUpdatedDesignation = request.newDesignations;

        /// Save in local list
        _updatedDesignations.add(request.newDesignations);

        /// Save in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'last_updated_designation', request.newDesignations);
        print("💾 Saved designation locally: ${request.newDesignations}");

        state = RequestState.success;
      } else {
        print("⚠️ Step 4: API error → ${res.message}");
        state = RequestState.error;
        errorMessage = res.message;
      }
    } catch (e) {
      print("💥 Step 5: Exception occurred → $e");
      state = RequestState.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> fetchManualDesignations() async {
    print("🔄 Setting manual designations list...");

    designationList = [
      DesignationItem(id: 1, name: "Project Manager"),
      DesignationItem(id: 2, name: "Team Member"),
      DesignationItem(id: 3, name: "Intern"),
    ];

    print("✅ Manual designations loaded: ${designationList.length}");
    state = RequestState.success;
    notifyListeners();
  }

  Future<void> showUpdateStatusDialog({
    required BuildContext context,
    required String designationId,
    required Future<void> Function() onUpdate,
  }) async {
    // Initially show loading state
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text("Updating Designation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Updating designation for ID: $designationId"),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );

    try {
      // Run the actual update function
      await onUpdate();

      // Close loading dialog
      Navigator.pop(context);

      // Show success dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text("Success"),
          content: const Text("Designation updated successfully!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      // Show error dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text("Error"),
          content: Text("Failed to update designation: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }


}
