// providers/payment_method_provider.dart
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request_state.dart';

class PaymentMethodProvider extends ChangeNotifier {
  RequestState state = RequestState.idle;
  String? errorMessage;
  String? selectedPaymentMethod;

  /// Set selected method from dropdown/textfield
  void setPaymentMethod(String value) {
    selectedPaymentMethod = value;
    print("✅ Selected payment method set: $value");
  }

  /// Internet check
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Save payment method (create only if new)
  Future<void> savePaymentMethod(PaymentMethodRequest request) async {
    if (!await _hasInternet()) {
      errorMessage = "No internet connection";
      state = RequestState.error;
      notifyListeners();
      print("❌ No internet connection");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("saved_payment_method");

    print("📌 Previously saved: $saved");
    print("📌 New method: ${request.paymentMethod}");

    // Skip if same
    if (saved == request.paymentMethod) {
      print("⚠️ Same method found → Skipping API call");
      state = RequestState.success;
      notifyListeners();
      return;
    }

    try {
      print("⏳ Sending request to create payment method...");
      state = RequestState.loading;
      notifyListeners();

      final response = await http.post(
        Uri.parse("https://abcwebservices.com/api/employee/create_payment_methoad.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("📥 API Raw Response: ${response.body}");
      final data = jsonDecode(response.body);

      final res = PaymentMethodResponse.fromJson(data);

      if (res.status == "success") {
        state = RequestState.success;
        await prefs.setString("saved_payment_method", request.paymentMethod);
        print("💾 Saved locally: ${request.paymentMethod}");
      } else {
        errorMessage = res.message;
        state = RequestState.error;
        print("⚠️ Error from API: ${res.message}");
      }
    } catch (e) {
      errorMessage = e.toString();
      state = RequestState.error;
      print("❌ Exception: $e");
    }

    notifyListeners();
  }

  /// Get saved method
  Future<String?> getSavedPaymentMethod() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("saved_payment_method");
    print("📌 Retrieved saved payment method: $saved");
    return saved;
  }
}
// models/payment_method_request.dart
class PaymentMethodRequest {
  final String userId;
  final String paymentMethod;
  final String createdBy;

  PaymentMethodRequest({
    required this.userId,
    required this.paymentMethod,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "payment_method": paymentMethod,
      "created_by": createdBy,
    };
  }
}
// models/payment_method_response.dart
class PaymentMethodResponse {
  final String status;
  final String message;

  PaymentMethodResponse({
    required this.status,
    required this.message,
  });

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    return PaymentMethodResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
