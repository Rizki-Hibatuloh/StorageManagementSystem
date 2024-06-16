import 'package:flutter/material.dart';
import 'package:storage_management_system/pages/login_page.dart';
import 'package:storage_management_system/pages/product_page.dart'; // Import halaman utama Anda
import 'package:storage_management_system/pages/register_page.dart';
import 'package:storage_management_system/services/auth_services.dart';

class LoginController extends State<LoginPage> {
  static late LoginController instance;
  late LoginPage widget;
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
    return LoginPageContent(controller: this);
  }

  void login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showSnackbar('All fields are required.');
      return;
    }

    Map<String, dynamic> result = await _authService.login(
      username: username,
      password: password,
    );

    if (result['success']) {
      _showSnackbar(result['message']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProductPage()), // Halaman utama Anda
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
            height: 2,
            fontSize: 20,
            color: Color.fromARGB(255, 241, 241, 241),
            fontWeight: FontWeight.bold, // Membuat teks bold
          ),
        ),
        backgroundColor: Colors.orange[300],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 10, // Tinggi bayangan
        margin: EdgeInsets.all(
            10), // Margin untuk memberikan ruang agar bayangan terlihat
      ),
    );
  }

  void goToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
}

void goToRegister(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const RegisterPage()),
  );
}
