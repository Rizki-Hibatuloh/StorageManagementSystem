import 'package:flutter/material.dart';
import 'package:storage_management_system/pages/product_page.dart'; // Pastikan import halaman home
import 'package:storage_management_system/pages/register_page.dart';
import 'package:storage_management_system/services/auth_services.dart';

class LoginController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showSnackbar(context, 'All fields are required.');
      return;
    }

    Map<String, dynamic> result = await _authService.login(
      username: username,
      password: password,
    );

    if (result['success']) {
      _showSnackbar(context, result['message']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProductPage()),
      );
    } else {
      _showSnackbar(context, result['message']);
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
        backgroundColor: Colors.orange[300],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 10,
        margin: EdgeInsets.all(10),
      ),
    );
  }

  void goToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }
}
