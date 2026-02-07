import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print('GET request error: $e');
      }
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print('POST request error: $e');
      }
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print('PUT request error: $e');
      }
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print('DELETE request error: $e');
      }
      throw Exception('Network error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    try {
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Request failed');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format');
      }
      rethrow;
    }
  }

  // Specific API methods
  Future<Map<String, dynamic>> getConversations() async {
    return await get('/conversations');
  }

  Future<Map<String, dynamic>> sendMessage(String conversationId, String message) async {
    return await post('/conversations/$conversationId/messages', {
      'message': message,
    });
  }

  Future<Map<String, dynamic>> getVideos({String? category}) async {
    String endpoint = '/videos';
    if (category != null) {
      endpoint += '?category=$category';
    }
    return await get(endpoint);
  }

  Future<Map<String, dynamic>> getQuizzes({String? category}) async {
    String endpoint = '/quizzes';
    if (category != null) {
      endpoint += '?category=$category';
    }
    return await get(endpoint);
  }

  Future<Map<String, dynamic>> submitQuizAnswer(String quizId, Map<String, dynamic> answers) async {
    return await post('/quizzes/$quizId/submit', answers);
  }

  Future<Map<String, dynamic>> getIeltsMockTests() async {
    return await get('/ielts/mock-tests');
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    return await get('/user/profile');
  }

  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    return await put('/user/profile', data);
  }

  Future<Map<String, dynamic>> getUserRewards() async {
    return await get('/user/rewards');
  }

  Future<Map<String, dynamic>> redeemReward(String rewardId) async {
    return await post('/user/rewards/$rewardId/redeem', {});
  }
}

