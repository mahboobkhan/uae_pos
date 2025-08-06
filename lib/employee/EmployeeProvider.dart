import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'AllEmployeeData.dart';
import 'employee_models.dart';

class EmployeeProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  AllEmployeeData? _data;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AllEmployeeData? get data => _data;

  Future<void> getFullData() async {
    _isLoading = true;
    _error = null;
    _data = null;
    notifyListeners();

    final url = Uri.parse(
      "https://abcwebservices.com/api/employee/get_all_employee_data.php",
    );

    try {
      final request = http.Request('GET', url);
      request.headers.addAll({
        "Accept": "application/json",
        "Content-Type": "application/json",
      });

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 15),
      );

      if (streamedResponse.statusCode == 200) {
        final responseBody = await streamedResponse.stream.bytesToString();

        final jsonMap = jsonDecode(responseBody);
        if (jsonMap is Map<String, dynamic>) {
          _data = AllEmployeeData.fromJson(jsonMap);
        } else {
          _error = "Invalid response format.";
        }
      } else {
        _error = "Server Error: ${streamedResponse.statusCode}";
      }
    } on TimeoutException {
      print("time out");
      _error = "Connection timed out.";
    } on http.ClientException catch (e) {
      print(e);
      _error = "Client error: ${e.message}";
    } catch (e) {
      print(e);
      _error = "Unexpected error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  // Helpers
  List<Employee>? get employees => _data?.employees;
  List<Profile>? get allProfiles => _data?.allProfiles;
  List<UserAccess>? get allUserAccess => _data?.allUserAccess;
  List<EmployeeType>? get allEmployeeTypes => _data?.allEmployeeTypes;
  List<Designation>? get allDesignations => _data?.allDesignations;
  List<Bank>? get allBanks => _data?.allBanks;
  List<BankAccount>? get allUserBankAccounts => _data?.allUserBankAccounts;
  List<Tag>? get allTags => _data?.allTags;
  List<Salary>? get allMonthlySalaries => _data?.allMonthlySalaries;
  List<PaymentMethod>? get allPaymentMethods => _data?.allPaymentMethods;
}
