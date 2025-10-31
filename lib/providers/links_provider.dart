import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LinksProvider extends ChangeNotifier {
  final String baseUrl = 'https://abcwebservices.com/api/links';

  bool isLoading = false;
  String? errorMessage;
  List<LinkModel> links = [];

  // 🔹 Fetch all links
  Future<void> fetchLinks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$baseUrl/get_links.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          links = (data['data'] as List)
              .map((item) => LinkModel.fromJson(item))
              .toList();
        } else {
          errorMessage = 'Failed to load links.';
        }
      } else {
        errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // 🔹 Add new link
  Future<bool> addLink({
    required String title,
    required String description,
    required String url,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_link.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
          'url': url,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        await fetchLinks();
        return true;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
    return false;
  }

  // 🔹 Update existing link
  Future<bool> updateLink({
    required String refId,
    required String title,
    required String description,
    required String url,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_link.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ref_id': refId,
          'title': title,
          'description': description,
          'url': url,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        await fetchLinks();
        return true;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
    return false;
  }

  // 🔹 Delete link
  Future<bool> deleteLink(String refId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete_link.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ref_id': refId}),
      );

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        links.removeWhere((link) => link.refId == refId);
        notifyListeners();
        return true;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
    return false;
  }
}
class LinkModel {
  final int? id;
  final String refId;
  final String title;
  final String description;
  final String url;
  final String createdAt;
  final String updatedAt;

  LinkModel({
    this.id,
    required this.refId,
    required this.title,
    required this.description,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      id: json['id'],
      refId: json['ref_id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ref_id': refId,
      'title': title,
      'description': description,
      'url': url,
    };
  }
}
