import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static String? token;
  File? _image;

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      var response = await Dio().post(
        'http://192.168.116.138:4000/users/login',
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
        'http://192.168.116.138:4000/users/register',
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

  Future<void> uploadProfile() async {
    if (_image != null) {
      final request = http.MultipartRequest(
          'POST', Uri.parse('https://192.168.116.138:4000/users/profile'));
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        _image!.readAsBytesSync(),
        filename: _image!.path,
      ));
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
      } else {
        print('Error uploading image: ${response.statusCode}');
      }
    }
  }
}
