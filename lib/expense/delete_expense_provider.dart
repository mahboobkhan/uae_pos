import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/request_state.dart';

class DeleteExpenseProvider with ChangeNotifier {
  RequestState _state = RequestState.idle;
  RequestState get state => _state;

  DeleteExpenseResponse? _response;
  DeleteExpenseResponse? get response => _response;

  Future<void> deleteExpense(String tid) async {
    const url = "https://abcwebservices.com/api/expenses/delete_expense.php";

    _state = RequestState.loading;
    notifyListeners();
    debugPrint("🟡 DeleteExpenseProvider: Loading... tid=$tid");

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({"tid": tid}),
        headers: {"Content-Type": "application/json"},
      );

      debugPrint("📡 API Called: $url");
      debugPrint("➡️ Request Body: { tid: $tid }");
      debugPrint("📥 Response Code: ${response.statusCode}");
      debugPrint("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _response = DeleteExpenseResponse.fromJson(jsonData);

        if (_response!.status) {
          _state = RequestState.success;
          debugPrint("✅ Delete Success: ${_response!.message}");
        } else {
          _state = RequestState.error;
          debugPrint("❌ Delete Failed: ${_response!.message}");
        }
      } else {
        _state = RequestState.error;
        debugPrint("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _state = RequestState.error;
      debugPrint("⚠️ Exception in deleteExpense: $e");
    }

    notifyListeners();
  }

  void reset() {
    _state = RequestState.idle;
    _response = null;
    notifyListeners();
    debugPrint("🔄 DeleteExpenseProvider reset to idle");
  }
}
class DeleteExpenseResponse {
  final bool status;
  final String message;

  DeleteExpenseResponse({
    required this.status,
    required this.message,
  });

  factory DeleteExpenseResponse.fromJson(Map<String, dynamic> json) {
    return DeleteExpenseResponse(
      status: json["status"] == true || json["status"] == 1,
      message: json["message"] ?? "",
    );
  }
}
