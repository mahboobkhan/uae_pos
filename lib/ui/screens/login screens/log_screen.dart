import 'package:abc_consultant/ui/screens/login%20screens/forgot_screen.dart';
import 'package:abc_consultant/ui/screens/login%20screens/sign_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/signup_provider.dart';
import '../../dialogs/custom_fields.dart';

class LogScreen extends StatefulWidget {
  final String? email;
  final String? password;

  const LogScreen({super.key, this.email, this.password});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email ?? 'yousafrana1212@gmail.com';
    _passwordController.text = widget.password ?? 'Eline@52';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset("assets/login_logo.png", fit: BoxFit.cover),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(height: 60),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 45,
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _emailController,
                                label: 'Email',
                                hintText: "",
                              ),
                              SizedBox(height: 20),
                              CustomTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hintText: "",
                                isPassword: true,
                              ),
                              SizedBox(height: 10),
                              FittedBox(
                                child: TextButton(
                                  onPressed: () {
                                    final email = _emailController.text.trim();
                                    if (email.isEmpty) {
                                      // Show error if no email entered
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          title: const Text("Email Required"),
                                          content: const Text("Please enter your email before resetting password."),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text("OK", style: TextStyle(color: Colors.black)),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }

                                    // Call the provider function
                                    Provider.of<SignupProvider>(context, listen: false)
                                        .sendForgetPasswordRequest(context, email);
                                  },
                                  child: Text(
                                    "Forgot/Update Password",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                              SizedBox(height: 31),
                              ElevatedButton(
                                onPressed: () {
                                  final provider = Provider.of<SignupProvider>(
                                    context,
                                    listen: false,
                                  );
                                  provider.handleLogin(
                                    context,
                                    _emailController,
                                    _passwordController,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(150, 48),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FittedBox(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Create New Account? ',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Signup',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
