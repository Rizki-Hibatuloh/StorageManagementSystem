import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_system/controllers/registerController.dart';
import 'package:storage_management_system/widgets/button.dart';
import 'package:storage_management_system/widgets/form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final RegisterController controller =
        Provider.of<RegisterController>(context);

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const <Widget>[
                    Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Create your account",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height - 220,
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
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => controller.pickImage(),
                            child: const Text('Pick Profile Picture'),
                          ),
                          if (controller.image != null)
                            Image.file(
                              controller.image!,
                              height: 50,
                              width: 100,
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: "Register",
                        onPressed: () => controller.register(context),
                        color: Colors.orange[800]!,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          InkWell(
                            onTap: () => Navigator.pushReplacementNamed(
                                context, '/login'),
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
