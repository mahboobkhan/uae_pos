import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ClientOrganizationEmployeeProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/client_organization_employee";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> employees = [];

  Future<void> getAllEmployees({required String clientRefId}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/get_all_organization_employees.php?client_ref_id=$clientRefId");

    try {
      if (kDebugMode) {
        print('Fetching employees from: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['data'] != null && data['data'] is List) {
            employees = List<Map<String, dynamic>>.from(data['data']);
            successMessage = "Employees fetched successfully";
          } else {
            employees = [];
            errorMessage = "No employees found";
          }
        } else {
          errorMessage = data['message'] ?? "Failed to fetch employees";
        }
      } else {
        errorMessage = "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> addEmployee({
    required String clientRefId,
    required String type,
    required String name,
    required String emirateId,
    required String workPermitNo,
    required String email,
    required String contactNo,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_organization_employee.php");

    final Map<String, dynamic> bodyData = {
      "client_ref_id": clientRefId,
      "type": type,
      "name": name,
      "emirate_id": emirateId,
      "work_permit_no": workPermitNo,
      "email": email,
      "contact_no": contactNo,
    };

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Adding employee to: $url');
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

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        successMessage = data['message'] ?? 'Employee added successfully';
        await getAllEmployees(clientRefId: clientRefId);
        return data['employee_ref_id'] as String?;
      } else {
        errorMessage = data['message'] ?? 'Failed to add employee';
      }
    } catch (e) {
      errorMessage = "Network error: $e";
    }

    isLoading = false;
    notifyListeners();
    return null;
  }

  Future<void> updateEmployee({
    required String employeeRefId,
    String? type,
    String? name,
    String? emirateId,
    String? workPermitNo,
    String? email,
    String? contactNo,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_organization_employee.php");

    final Map<String, dynamic> bodyData = {"employee_ref_id": employeeRefId};
    if (type != null && type.isNotEmpty) bodyData["type"] = type;
    if (name != null && name.isNotEmpty) bodyData["name"] = name;
    if (emirateId != null && emirateId.isNotEmpty) bodyData["emirate_id"] = emirateId;
    if (workPermitNo != null && workPermitNo.isNotEmpty) bodyData["work_permit_no"] = workPermitNo;
    if (email != null && email.isNotEmpty) bodyData["email"] = email;
    if (contactNo != null && contactNo.isNotEmpty) bodyData["contact_no"] = contactNo;

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Updating employee at: $url');
        print('Request body: $body');
      }

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        successMessage = data['message'] ?? 'Employee updated successfully';
        // Refresh the employee list
        final clientRefId = employees.isNotEmpty ? employees.first['client_ref_id'] : '';
        if (clientRefId.isNotEmpty) {
          await getAllEmployees(clientRefId: clientRefId);
        }
      } else {
        errorMessage = data['message'] ?? 'Failed to update employee';
      }
    } catch (e) {
      errorMessage = "Network error: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteEmployee({required String employeeRefId}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/delete_organization_employee.php?employee_ref_id=$employeeRefId");

    try {
      if (kDebugMode) {
        print('Deleting employee at: $url');
      }

      final response = await http.delete(url);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        successMessage = data['message'] ?? 'Employee deleted successfully';
        // Remove the employee from local list
        employees.removeWhere((emp) => emp['employee_ref_id'] == employeeRefId);
      } else {
        errorMessage = data['message'] ?? 'Failed to delete employee';
      }
    } catch (e) {
      errorMessage = "Network error: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}