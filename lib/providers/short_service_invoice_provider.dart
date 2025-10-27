import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ShortServiceInvoiceProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/projects/short_services";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  Map<String, dynamic>? invoiceData;

  /// ✅ Get Short Service Invoice by ref_id
  Future<Map<String, dynamic>?> getShortServiceInvoice({
    required String refId,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    invoiceData = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/short_service_invoice.php");

    final body = json.encode({
      "ref_id": refId,
    });

    try {
      if (kDebugMode) {
        print('Fetching short service invoice from: $url');
        print('Request body: $body');
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          invoiceData = data['invoice'];
          successMessage = data['message'] ?? "Invoice fetched successfully";
          if (kDebugMode) {
            print('Invoice fetched successfully: ${invoiceData?['ref_id']}');
          }
        } else {
          errorMessage = data['message'] ?? "Failed to fetch invoice";
          if (kDebugMode) {
            print('API returned error: $errorMessage');
          }
        }
      } else {
        errorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
        if (kDebugMode) {
          print('HTTP error: $errorMessage');
        }
      }
    } catch (e) {
      errorMessage = "Network error: $e";
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }

    isLoading = false;
    notifyListeners();
    return invoiceData;
  }

  /// Clear messages and data
  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    invoiceData = null;
    notifyListeners();
  }
}

