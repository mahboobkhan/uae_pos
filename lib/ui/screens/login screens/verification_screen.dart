import 'package:flutter/material.dart';

import '../../dialogs/custom_fields.dart';
import 'log_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _adminGmailController = TextEditingController();

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Verification Required',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          controller: _nameController,
                          label: 'Name',
                          hintText: "",
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _adminGmailController,
                          label: 'Enter Code',
                          hintText: "00 00 00",
                          suffixIcon: TextButton(
                            onPressed: () {
                              // Do something (e.g. validate email)
                            },
                            child: const Text(
                              "Resend",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 62.0),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'abc@email.com',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _gmailController,
                          label: 'Enter Code',
                          hintText: "00 00 00",
                          suffixIcon: TextButton(
                            onPressed: () {
                              // Do something (e.g. validate email)
                            },
                            child: const Text(
                              "Resend",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 62.0),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'admin@email.com',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async { Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LogScreen()),
                          );},
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "60 - Seconds",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 110 ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LogScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Already Registered? ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  // Gray color for this part
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration:
                                          TextDecoration
                                              .underline, // Underline only "Login"
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
            ),
          ),
        ],
      ),
    );
  }
}
