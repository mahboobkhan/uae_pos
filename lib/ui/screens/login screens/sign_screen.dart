import 'package:abc_consultant/ui/screens/login%20screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/signup_provider.dart';
import '../../../widgets/loading_dialog.dart';
import '../../dialogs/custom_fields.dart';
import 'log_screen.dart';

class SignScreen extends StatefulWidget {
  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  List<String> missingFields = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);

    return Scaffold(
      body: Row(
        children: [
          // Left Side - Image
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset("assets/login_logo.png", fit: BoxFit.cover),
            ),
          ),
          // Right Side - Form
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Create New Account',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Name
                        CustomTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hintText: 'Enter your full name',
                        ),
                        const SizedBox(height: 20),
                        // Email
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hintText: 'abc@email.com',
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Password',
                          hintText: "Password",
                          controller: _passwordController,
                          isPassword: true,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Confirm Password',
                          hintText: "Confirm Password",
                          controller: _confirmPasswordController,
                          isPassword: true,
                        ),
                        const SizedBox(height: 30),

                        // Sign Up Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {

                            final name = _nameController.text.trim();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final confirmPassword =
                                _confirmPasswordController.text.trim();
                            if (name.isEmpty) missingFields.add("Name");
                            if (email.isEmpty) missingFields.add("Email");
                            if (password.isEmpty) missingFields.add("Password");
                            if (confirmPassword.isEmpty)
                              missingFields.add("Confirm Password");

                            if (missingFields.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: const Text("Missing Fields"),
                                      content: Text(
                                        "Please fill in the following:\n\n• ${missingFields.join("\n• ")}",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    ),
                              );
                              return;
                            }

                            if (name.isEmpty ||
                                email.isEmpty ||
                                password.isEmpty ||
                                confirmPassword.isEmpty) {
                              showError(context, "All fields are required");
                              return;
                            }

                            if (!gmailRegex.hasMatch(email)) {
                              showError(
                                context,
                                "Please enter a valid Gmail address",
                              );
                              return;
                            }

                            if (password != confirmPassword) {
                              showError(context, "Passwords do not match");
                              return;
                            }

                            showLoadingDialog(context);
                            final result = await provider.registerUser(
                              name: name,
                              email: email,
                              password: password,
                            );
                            hideLoadingDialog(context);

                            if (result != null && result['error'] == null) {
                              final userId = result['user_id'];
                              final email = result['email'];
                              final adminEmail = result['admin_email'];

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VerificationScreen(
                                    userId: userId,
                                    email: email,
                                    adminEmail: adminEmail,
                                  ),
                                ),
                              );
                            } else {
                              showError(context, result?['error'] ?? "Unknown error");
                            }

                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already Registered? ',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
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

  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }
}
