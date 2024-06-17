import 'package:flutter/material.dart';
import 'package:storage_management_system/pages/login_page.dart';
import 'package:storage_management_system/pages/register_page.dart';
import 'package:storage_management_system/services/auth_services.dart';

class RegisterController extends State<RegisterPage> {
  static late RegisterController instance;
  late RegisterPage widget;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterPageContent(controller: this);
  }

  // RegisterController
  void register() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showSnackbar('All fields are required.');
      return;
    }

    Map<String, dynamic> result = await _authService.register(
      username: username,
      password: password,
    );

    if (result['success']) {
      _showSnackbar(result['message']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()), // Halaman login Anda
      );
    } else {
      _showSnackbar(result['message']);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont', // Mengganti font
          ),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 10,
        margin: EdgeInsets.all(10),
      ),
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
