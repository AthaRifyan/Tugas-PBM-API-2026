import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // ─── TOKEN ───────────────────────────────────────────
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  // ─── HEADERS ─────────────────────────────────────────
  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ─── LOGIN ────────────────────────────────────────────
  static Future<Map<String, dynamic>> login(String nim) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': nim,
        'password': nim,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      await saveToken(data['data']['token']);
      return {'success': true, 'data': data['data']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login gagal'};
    }
  }

  // ─── GET PRODUCTS ─────────────────────────────────────
  static Future<List<ProductModel>> getProducts() async {
    final url = Uri.parse('$baseUrl/api/products');
    final headers = await _authHeaders();
    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      final List products = data['data']['products'];
      return products.map((e) => ProductModel.fromJson(e)).toList();
    }
    return [];
  }

  // ─── ADD PRODUCT ──────────────────────────────────────
  static Future<Map<String, dynamic>> addProduct({
    required String name,
    required int price,
    required String description,
  }) async {
    final url = Uri.parse('$baseUrl/api/products');
    final headers = await _authHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200 || response.statusCode == 201,
      'message': data['message'] ?? '',
    };
  }

  // ─── DELETE PRODUCT ───────────────────────────────────
  static Future<bool> deleteProduct(int id) async {
    final url = Uri.parse('$baseUrl/api/products/$id');
    final headers = await _authHeaders();
    final response = await http.delete(url, headers: headers);
    return response.statusCode == 200;
  }

  // ─── SUBMIT TUGAS ─────────────────────────────────────
  static Future<Map<String, dynamic>> submitTugas({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    final url = Uri.parse('$baseUrl/api/products/submit');
    final headers = await _authHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200 || response.statusCode == 201,
      'message': data['message'] ?? '',
    };
  }
}