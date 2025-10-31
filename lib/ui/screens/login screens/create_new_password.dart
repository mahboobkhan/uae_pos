import 'package:abc_consultant/providers/signup_provider.dart';
import 'package:abc_consultant/ui/screens/login%20screens/log_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/loading_dialog.dart';
import '../../dialogs/custom_fields.dart' show CustomTextField;

class CreateNewPassword extends StatefulWidget {
  final String userId;
  const CreateNewPassword({super.key, required this.userId});

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
                SizedBox(height: 60),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        FittedBox(
                          child: Text(
                            'Create New Password',
                            style: TextStyle(
                              color: AppColors.redColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
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
                              SizedBox(height: 64),
                              ElevatedButton(
                                onPressed: () async {
                                  final newPass = _emailController.text.trim();
                                  final confirmPass = _passwordController.text.trim();

                                  if (newPass.isEmpty || confirmPass.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please enter password in both fields')),
                                    );
                                    return;
                                  }

                                  if (newPass != confirmPass) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Passwords do not match')),
                                    );
                                    return;
                                  }
                                  showLoadingDialog(context);
                                  final provider = Provider.of<SignupProvider>(context, listen: false);
                                  final result = await provider.updatePassword(
                                    userId: widget.userId,
                                    newPassword: newPass,
                                  );

                                  if (result == null) {
                                    // Success → Go to login screen
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Password updated successfully!')),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LogScreen()),
                                    );
                                  } else {
                                    // Show error
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(result)),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(150, 48),
                                  backgroundColor: AppColors.redColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
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
                        MaterialPageRoute(builder: (context) => LogScreen()),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.white;
                          }
                          return null;
                        },
                      ),
                    ),
                    child: RichText(
                      text: const TextSpan(
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
