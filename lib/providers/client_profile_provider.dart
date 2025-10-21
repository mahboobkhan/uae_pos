import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ClientProfileProvider extends ChangeNotifier {
  final String baseUrl = "https://abcwebservices.com/api/clients";

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Map<String, dynamic>> clients = [];
  Map<String, dynamic>? clientsSummary = {};
  
  // Filter properties
  String? clientTypeFilter; // 'individual' or 'establishment'
  String? typeFilter; // 'regular' or 'walking'
  String? startDateFilter;
  String? endDateFilter;

  Future<void> getAllClients({int page = 1, int perPage = 20}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    // Build query parameters
    final Map<String, String> queryParams = {};
    
    if (clientTypeFilter != null && clientTypeFilter!.isNotEmpty) {
      queryParams['type'] = clientTypeFilter!.toLowerCase();
    }
    
    if (typeFilter != null && typeFilter!.isNotEmpty) {
      queryParams['work'] = typeFilter!.toLowerCase();
    }
    
    if (startDateFilter != null && startDateFilter!.isNotEmpty) {
      queryParams['start_date'] = startDateFilter!;
    }
    
    if (endDateFilter != null && endDateFilter!.isNotEmpty) {
      queryParams['end_date'] = endDateFilter!;
    }

    final url = Uri.parse("$baseUrl/get_client_profiles.php").replace(queryParameters: queryParams);

    try {
      if (kDebugMode) {
        print('=== CLIENT FILTER DEBUG ===');
        print('Base URL: $baseUrl');
        print('Query parameters: $queryParams');
        print('Final URL: $url');
        print('Client Type Filter: $clientTypeFilter');
        print('Type Filter: $typeFilter');
        print('Start Date Filter: $startDateFilter');
        print('End Date Filter: $endDateFilter');
        print('========================');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (data['clients'] != null && data['clients'] is List) {
            clients = List<Map<String, dynamic>>.from(data['clients']);
            // Store clients summary if available
            if (data['clients_summary'] != null) {
              clientsSummary = Map<String, dynamic>.from(data['clients_summary']);
            }
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
    required String clientType, // establishment | individual
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

  // Set filters
  void setFilters({
    String? clientType,
    String? type,
    String? startDate,
    String? endDate,
  }) {
    clientTypeFilter = clientType;
    typeFilter = type;
    startDateFilter = startDate;
    endDateFilter = endDate;
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    clientTypeFilter = null;
    typeFilter = null;
    startDateFilter = null;
    endDateFilter = null;
    notifyListeners();
  }

  // Get filtered clients based on context
  List<Map<String, dynamic>> get filteredClients {
    // If clientTypeFilter is set, use API-level filtering
    if (clientTypeFilter != null) {
      return clients; // API already filtered by client_type
    }
    
    // Otherwise, return all clients (for Client Main Screen)
    return clients;
  }

  // Get establishment clients only (for Company Screen)
  List<Map<String, dynamic>> get establishmentClients {
    final filtered = clients.where((client) {
      // Method 1: Explicit establishment types (highest priority)
      final isExplicitEstablishment = 
          client['client_type'] == 'establishment' || 
          client['client_type'] == 'organization';
      
      // Method 2: Has establishment-specific fields with actual values
      final hasEstablishmentFields = 
          (client['trade_license_no'] != null && client['trade_license_no'].toString().trim().isNotEmpty) ||
          (client['company_code'] != null && client['company_code'].toString().trim().isNotEmpty) ||
          (client['establishment_no'] != null && client['establishment_no'].toString().trim().isNotEmpty) ||
          (client['echannel_name'] != null && client['echannel_name'].toString().trim().isNotEmpty) ||
          (client['echannel_id'] != null && client['echannel_id'].toString().trim().isNotEmpty) ||
          (client['echannel_password'] != null && client['echannel_password'].toString().trim().isNotEmpty) ||
          (client['physical_address'] != null && client['physical_address'].toString().trim().isNotEmpty);
      
      // Method 3: Business work types (Regular/Walking) - but be more strict
      final hasBusinessWork = 
          (client['client_work'] == 'Regular' || client['client_work'] == 'Walking') &&
          client['client_work'] != 'Personal' &&
          client['client_work'] != 'Individual' &&
          client['client_work'] != null &&
          client['client_work'].toString().trim().isNotEmpty;
      
      // Additional check: Exclude clients that are clearly individual/personal
      final isNotPersonalClient = 
          client['client_type'] != 'personal' &&
          client['client_type'] != 'individual' &&
          client['name'] != null &&
          !client['name'].toString().toLowerCase().contains('personal') &&
          !client['name'].toString().toLowerCase().contains('individual');
      
      // Only show if it meets establishment criteria AND is not a personal client
      final shouldShow = (isExplicitEstablishment || hasEstablishmentFields || hasBusinessWork) && isNotPersonalClient;
      
      return shouldShow;
    }).toList();
    
    if (kDebugMode) {
      print('🔍 ESTABLISHMENT FILTER RESULTS:');
      print('  - Total clients loaded: ${clients.length}');
      print('  - Establishment clients shown: ${filtered.length}');
      print('  - Clients filtered out: ${clients.length - filtered.length}');
    }
    
    return filtered;
  }

  // Get individual clients only (for Individual Screen)
  List<Map<String, dynamic>> get individualClients {
    final filtered = clients.where((client) {
      // Method 1: Explicit individual types
      final isExplicitIndividual = 
          client['client_type'] == 'individual' || 
          client['client_type'] == 'personal';
      
      // Method 2: Check if it's NOT an establishment (reverse of establishment logic)
      final isNotEstablishment = 
          client['client_type'] != 'establishment' &&
          client['client_type'] != 'organization' &&
          (client['trade_license_no'] == null || client['trade_license_no'].toString().trim().isEmpty) &&
          (client['company_code'] == null || client['company_code'].toString().trim().isEmpty) &&
          (client['establishment_no'] == null || client['establishment_no'].toString().trim().isEmpty) &&
          (client['echannel_name'] == null || client['echannel_name'].toString().trim().isEmpty) &&
          (client['echannel_id'] == null || client['echannel_id'].toString().trim().isEmpty) &&
          (client['echannel_password'] == null || client['echannel_password'].toString().trim().isEmpty) &&
          (client['physical_address'] == null || client['physical_address'].toString().trim().isEmpty);
      
      // Method 3: Personal work types
      final hasPersonalWork = 
          client['client_work'] == 'Personal' ||
          client['client_work'] == 'Individual' ||
          (client['client_work'] != 'Regular' && client['client_work'] != 'Walking');
      
      // Show if it's explicitly individual OR not an establishment OR has personal work
      final shouldShow = isExplicitIndividual || isNotEstablishment || hasPersonalWork;
      
      return shouldShow;
    }).toList();
    
    if (kDebugMode) {
      print('🔍 INDIVIDUAL FILTER RESULTS:');
      print('  - Total clients loaded: ${clients.length}');
      print('  - Individual clients shown: ${filtered.length}');
      print('  - Clients filtered out: ${clients.length - filtered.length}');
    }
    
    return filtered;
  }
}
