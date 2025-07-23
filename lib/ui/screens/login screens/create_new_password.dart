import 'package:abc_consultant/ui/screens/login%20screens/log_screen.dart';
import 'package:flutter/material.dart';

import '../../dialogs/custom_fields.dart' show CustomTextField;

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
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
                SizedBox(height: 90),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Text(
                          'Create New Password',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 40,),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 45,
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _emailController,
                                label: 'Password',
                                hintText: "",
                                isPassword: true,
                              ),
                              SizedBox(height: 20),
                              CustomTextField(
                                controller: _passwordController,
                                label: 'Confirm Password',
                                hintText: "",
                                isPassword: true,
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LogScreen(),
                                    ),
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
                                  "Submit",
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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogScreen()),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
