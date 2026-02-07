import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  Map<String, dynamic>? _user;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;

  final ApiService _apiService = ApiService();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response['success'] == true) {
        _token = response['data']['token'];
        _user = response['data']['user'];
        _isLoggedIn = true;

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_data', _user.toString());

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });

      if (response['success'] == true) {
        _token = response['data']['token'];
        _user = response['data']['user'];
        _isLoggedIn = true;

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_data', _user.toString());

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Register error: $e');
      }
      return false;
    }
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        await _apiService.post('/auth/logout', {});
      }
    } catch (e) {
      if (kDebugMode) {
        print('Logout error: $e');
      }
    } finally {
      _token = null;
      _user = null;
      _isLoggedIn = false;

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');

      notifyListeners();
    }
  }

  Future<bool> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        _token = token;
        
        // Verify token with server
        final response = await _apiService.get('/auth/me');
        if (response['success'] == true) {
          _user = response['data'];
          _isLoggedIn = true;
          notifyListeners();
          return true;
        } else {
          // Token is invalid, clear it
          await logout();
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Auth check error: $e');
      }
      return false;
    }
  }
}

