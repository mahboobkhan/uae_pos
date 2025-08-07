import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeeProvider extends ChangeNotifier {
  EmployeeStatus status = EmployeeStatus.idle;
  List<Employee> employees = [];
  String errorMessage = '';

  /// Fetch employees from API
  Future<void> fetchEmployees() async {
    print("STEP 1: Checking internet connection...");
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print("STEP 1 RESULT: No internet connection");
      status = EmployeeStatus.error;
      errorMessage = "No internet connection";
      notifyListeners();
      return;
    }

    try {
      print("STEP 2: Setting state to LOADING...");
      status = EmployeeStatus.loading;
      notifyListeners();

      print("STEP 3: Sending GET request to API...");
      final url = Uri.parse(
        "https://abcwebservices.com/api/employee/get_all_employee_data.php",
      );
      final response = await http.get(url);

      print("STEP 4: Response received, statusCode = ${response.statusCode}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print("STEP 5: Parsing response JSON...");

        final employeeResponse = EmployeeResponse.fromJson(jsonData);

        if (employeeResponse.status) {
          employees = employeeResponse.employees;
          print("STEP 6: Parsed ${employees.length} employees successfully");
          status = EmployeeStatus.success;
        } else {
          print("STEP 6: API returned an error message");
          errorMessage = employeeResponse.message;
          status = EmployeeStatus.error;
        }
      } else {
        print("STEP 6: HTTP error occurred");
        errorMessage = "Failed to load data: ${response.statusCode}";
        status = EmployeeStatus.error;
      }
    } catch (e) {
      print("STEP 6: Exception occurred - $e");
      errorMessage = e.toString();
      status = EmployeeStatus.error;
    }

    print("STEP 7: Notifying listeners about new state");
    notifyListeners();
  }
}

class Employee {
  final String id;
  final String name;
  final String email;

  Employee({required this.id, required this.name, required this.email});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class EmployeeResponse {
  final bool status;
  final String message;
  final List<Employee> employees;

  EmployeeResponse({
    required this.status,
    required this.message,
    required this.employees,
  });

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      employees:
          (json['data'] as List<dynamic>? ?? [])
              .map((e) => Employee.fromJson(e))
              .toList(),
    );
  }
}

enum EmployeeStatus { idle, loading, success, error }
