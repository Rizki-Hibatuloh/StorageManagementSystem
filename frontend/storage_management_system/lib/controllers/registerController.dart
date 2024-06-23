import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storage_management_system/services/auth_services.dart';

class RegisterController with ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? _image;
  File? get image => _image;

  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _image = File(pickedImage.path);
      notifyListeners();
    }
  }

  Future<void> register(BuildContext context) async {
    try {
      String username = usernameController.text.trim();
      String password = passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        _showSnackbar(context, 'All fields are required');
        return;
      }

      // Panggil AuthService untuk registrasi
      Map<String, dynamic> result = await AuthService().register(
        username: username,
        password: password,
        image: _image!,
      );

      if (result['success']) {
        _showSnackbar(context, result['message']);
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showSnackbar(context, result['message']);
      }
    } catch (e) {
      print('Registration failed: $e');
      _showSnackbar(context, 'Registration failed');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            height: 2,
            fontSize: 20,
            color: Color.fromARGB(255, 241, 241, 241),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 10,
        margin: EdgeInsets.all(10),
      ),
    );
  }
}
