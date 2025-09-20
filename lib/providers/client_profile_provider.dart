import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ClientProfileProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/clients";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> clients = [];

  Future<void> getAllClients({int page = 1, int perPage = 20}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/get_client_profiles.php");

    try {
      if (kDebugMode) {
        print('Fetching clients from: $url');
      }

      final response = await http.post(url, body: "");

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['clients'] != null && data['clients'] is List) {
            clients = List<Map<String, dynamic>>.from(data['clients']);
            successMessage = "Clients fetched";
          } else {
            clients = [];
            errorMessage = "No clients found";
          }
        } else {
          errorMessage = data['message'] ?? "Failed to fetch clients";
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

  Future<String?> addClient({
    required String name,
    required String clientType, // organization | individual
    required String clientWork,
    required String email,
    required String phone1,
    String? phone2,
    List<String>? tags,
    String? tradeLicenseNo,
    String? companyCode,
    String? establishmentNo,
    String? physicalAddress,
    String? echannelName,
    String? echannelId,
    String? echannelPassword,
    String? extraNote,
    List<String>? documents,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/add_client_profile.php");

    final Map<String, dynamic> bodyData = {"name": name, "client_type": clientType, "client_work": clientWork, "email": email, "phone1": phone1,"documents": documents ?? []};
    if (phone2 != null && phone2.isNotEmpty) bodyData["phone2"] = phone2;
    if (tags != null) bodyData["tags"] = tags;
    if (tradeLicenseNo != null && tradeLicenseNo.isNotEmpty) bodyData["trade_license_no"] = tradeLicenseNo;
    if (companyCode != null && companyCode.isNotEmpty) bodyData["company_code"] = companyCode;
    if (establishmentNo != null && establishmentNo.isNotEmpty) bodyData["establishment_no"] = establishmentNo;
    if (physicalAddress != null && physicalAddress.isNotEmpty) bodyData["physical_address"] = physicalAddress;
    if (echannelName != null && echannelName.isNotEmpty) bodyData["echannel_name"] = echannelName;
    if (echannelId != null && echannelId.isNotEmpty) bodyData["echannel_id"] = echannelId;
    if (echannelPassword != null && echannelPassword.isNotEmpty) bodyData["echannel_password"] = echannelPassword;
    if (extraNote != null && extraNote.isNotEmpty) bodyData["extra_note"] = extraNote;

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Adding client to: $url');
        print('Request body: $body');
      }

      final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        successMessage = data['message'] ?? 'Client created';
        await getAllClients();
        return data['client_ref_id'] as String?;
      } else {
        errorMessage = data['message'] ?? 'Failed to create client';
      }
    } catch (e) {
      errorMessage = "Network error: $e";
    }

    isLoading = false;
    notifyListeners();
    return null;
  }

  Future<void> updateClient({
    required String clientRefId,
    String? name,
    String? email,
    String? phone1,
    String? phone2,
    List<String>? tags,
    String? clientType,
    String? clientWork,
    String? tradeLicenseNo,
    String? companyCode,
    String? establishmentNo,
    String? physicalAddress,
    String? echannelName,
    String? echannelId,
    String? echannelPassword,
    String? extraNote,
    List<String>? documents,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/update_client_profile.php");

    final Map<String, dynamic> bodyData = {"client_ref_id": clientRefId};
    if (name != null && name.isNotEmpty) bodyData["name"] = name;
    if (email != null && email.isNotEmpty) bodyData["email"] = email;
    if (phone1 != null && phone1.isNotEmpty) bodyData["phone1"] = phone1;
    if (phone2 != null && phone2.isNotEmpty) bodyData["phone2"] = phone2;
    if (tags != null) bodyData["tags"] = tags;
    if (clientType != null && clientType.isNotEmpty) bodyData["client_type"] = clientType;
    if (clientWork != null && clientWork.isNotEmpty) bodyData["client_work"] = clientWork;
    if (tradeLicenseNo != null && tradeLicenseNo.isNotEmpty) bodyData["trade_license_no"] = tradeLicenseNo;
    if (companyCode != null && companyCode.isNotEmpty) bodyData["company_code"] = companyCode;
    if (establishmentNo != null && establishmentNo.isNotEmpty) bodyData["establishment_no"] = establishmentNo;
    if (physicalAddress != null && physicalAddress.isNotEmpty) bodyData["physical_address"] = physicalAddress;
    if (echannelName != null && echannelName.isNotEmpty) bodyData["echannel_name"] = echannelName;
    if (echannelId != null && echannelId.isNotEmpty) bodyData["echannel_id"] = echannelId;
    if (echannelPassword != null && echannelPassword.isNotEmpty) bodyData["echannel_password"] = echannelPassword;
    if (extraNote != null && extraNote.isNotEmpty) bodyData["extra_note"] = extraNote;
    if (documents != null) bodyData["documents"] = documents;

    final body = json.encode(bodyData);

    try {
      if (kDebugMode) {
        print('Updating client at: $url');
        print('Request body: $body');
      }

      final response = await http.put(url, headers: {"Content-Type": "application/json"}, body: body);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        successMessage = data['message'] ?? 'Client updated';
        await getAllClients();
      } else {
        errorMessage = data['message'] ?? 'Failed to update client';
      }
    } catch (e) {
      errorMessage = "Network error: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteClient({required String clientRefId}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final url = Uri.parse("$baseUrl/delete_client_profile.php");
    final body = json.encode({"client_ref_id": clientRefId});

    try {
      if (kDebugMode) {
        print('Deleting client at: $url');
        print('Request body: $body');
      }

      final response = await http.delete(url, headers: {"Content-Type": "application/json"}, body: body);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        successMessage = data['message'] ?? 'Client deleted';
        await getAllClients();
      } else {
        errorMessage = data['message'] ?? 'Failed to delete client';
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
