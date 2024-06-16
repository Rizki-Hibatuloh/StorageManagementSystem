import 'package:flutter/material.dart';
import 'package:storage_management_system/controllers/loginController.dart';
import 'package:storage_management_system/widgets/button.dart';
import 'package:storage_management_system/widgets/form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginController createState() => LoginController();
}

class LoginPageContent extends StatelessWidget {
  final LoginController controller;

  const LoginPageContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[800]!,
              Colors.orange[700]!,
              Colors.orange[500]!,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 80),
                      CustomForm(
                        children: [
                          CustomTextField(
                            hintText: "Username",
                            controller: controller.usernameController,
                          ),
                          CustomTextField(
                            hintText: "Password",
                            controller: controller.passwordController,
                            isPassword: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: "Login",
                        onPressed: controller.login,
                        color: Colors.orange[800]!,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          InkWell(
                            onTap: () => controller.goToRegister(context),
                            child: const Text(
                              "Signup",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
