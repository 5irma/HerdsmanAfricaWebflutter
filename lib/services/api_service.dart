import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/user_model.dart';

class ApiService {
  static const String _baseUrl = AppConstants.baseUrl;
  static const Duration _timeout = Duration(
    seconds: AppConstants.timeoutDuration,
  );

  static Future<List<User>> getUsers() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/users'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<User> createUser(User user) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/users'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(user.toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode == 201) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
