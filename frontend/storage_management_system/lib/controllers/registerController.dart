import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storage_management_system/services/auth_services.dart';

class RegisterController extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  File? _image;

  File? get image => _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners(); // Memberitahu listener bahwa state telah berubah
    }
  }

  Future<void> register(BuildContext context) async {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    var result = await AuthService().register(
      username: usernameController.text,
      password: passwordController.text,
      image: _image!,
    );

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  void goToRegister(BuildContext context) {
    Navigator.pushNamed(
        context, '/register'); // Gunakan Navigator.pushNamed untuk rute bernama
  }

  void goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
