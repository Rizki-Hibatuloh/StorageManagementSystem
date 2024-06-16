import 'package:dio/dio.dart';

class AuthService {
  static String? token;

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      var response = await Dio().post(
        'http://192.168.149.138:4000/users/login',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {'username': username, 'password': password},
      );
      Map<String, dynamic> obj = response.data;

      if (response.statusCode == 200) {
        token = obj['token'];
        return {'success': true, 'message': obj['status']};
      } else {
        return {'success': false, 'message': obj['err']};
      }
    } on DioException catch (e) {
      print("Login failed: ${e.response?.data}");
      return {
        'success': false,
        'message': e.response?.data['err'] ?? 'Login failed',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
  }) async {
    try {
      var response = await Dio().post(
        'http://192.168.149.138:4000/users/register',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'username': username,
          'password': password,
        },
      );
      Map<String, dynamic> obj = response.data;

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        return {'success': false, 'message': obj['err']};
      }
    } on DioException catch (e) {
      print("Registration failed: ${e.response?.data}");
      return {
        'success': false,
        'message': e.response?.data['err'] ?? 'Registration failed',
      };
    }
  }
}
