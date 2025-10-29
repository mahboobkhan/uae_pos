import 'dart:async';

import 'package:abc_consultant/ui/screens/login%20screens/create_new_password.dart';
import 'package:abc_consultant/ui/screens/login%20screens/log_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/signup_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/loading_dialog.dart';
import '../../dialogs/custom_fields.dart';

class ForgotScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String adminEmail;

  const ForgotScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.adminEmail,
  });

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  List<String> missingFields = [];

  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _adminGmailController = TextEditingController();

  int countdown = 60;
  bool isCountdownRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startCountdown(); // start auto time
  }

  void startCountdown() {
    setState(() {
      isCountdownRunning = true;
      countdown = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          isCountdownRunning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _gmailController.dispose();
    _adminGmailController.dispose();
    super.dispose();
  }

  Future<bool> _handleBackNavigation() async {
    if (isCountdownRunning) {
      bool shouldLeave = await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              content: const Text(" Are you sure you want to leave?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
      );
      return shouldLeave;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);

    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: Scaffold(
        backgroundColor: Colors.white12,
        body: Row(
          children: [
            Expanded(
              flex: 4,
              child: SizedBox(
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
                          SizedBox(height: 40),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Request For Forgot Password',
                              style: TextStyle(
                                color: AppColors.redColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                controller: _gmailController,
                                label: 'Enter Code',
                                hintText: "00 00 00",
                                suffixIcon:
                                    isCountdownRunning
                                        ? const SizedBox()
                                        : TextButton(
                                          onPressed: () async {
                                            // Step 1: Resend the verification PIN
                                            final resendError = await provider
                                                .resendVerificationPin(
                                                  userId: widget.userId,
                                                  to: "user", // or "user", or "both"
                                                );

                                            if (resendError != null) {
                                              showError(context, resendError);
                                              return;
                                            } else {
                                              startCountdown();
                                              showSuccess(
                                                context,
                                                "Verification code resent successfully!",
                                              );
                                            }
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
                              Text(
                                widget.email,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: _adminGmailController,
                                label: 'Enter Code',
                                hintText: "00 00 00",
                                suffixIcon:
                                    isCountdownRunning
                                        ? const SizedBox()
                                        : TextButton(
                                          onPressed: () async {
                                            // Step 1: Resend the verification PIN
                                            final resendError = await provider
                                                .resendVerificationPin(
                                                  userId: widget.userId,
                                                  to: "admin", // or "user", or "both"
                                                );

                                            if (resendError != null) {
                                              showError(context, resendError);
                                              return;
                                            } else {
                                              startCountdown();
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Verification code resent successfully!",
                                                  ),
                                                  backgroundColor: Colors.green,
                                                  // Optional: Success color
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  duration: Duration(
                                                    seconds: 3,
                                                  ),
                                                ),
                                              );
                                            }
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
                              Text(
                                widget.adminEmail,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),

                          /// Submit Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              backgroundColor: AppColors.redColor,
                            ),
                            onPressed: () async {
                              final gmail = _gmailController.text.trim();
                              final adminGmail =
                                  _adminGmailController.text.trim();
                              if (gmail.isEmpty) missingFields.add("User Pin");
                              if (adminGmail.isEmpty)
                                missingFields.add("Admin Pin");

                              if (gmail.isEmpty || adminGmail.isEmpty) {
                                showError(context, "Please Enter the pin");
                                return;
                              }
                              showLoadingDialog(context);

                              final error = await provider.verifyUser(
                                userId: widget.userId,
                                pinUser: _gmailController.text.trim(),
                                pinAdmin: _adminGmailController.text.trim(),
                              );

                              if (error == null) {
                                showLoadingDialog(context);
                                hideLoadingDialog(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => CreateNewPassword(
                                          userId: widget.userId,
                                        ),
                                  ),
                                );
                              } else {
                                showError(context, error);
                              }
                            },
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
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

                          /// Countdown
                          if (isCountdownRunning)
                            Text(
                              "$countdown - Seconds",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  /// Already Registered
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: TextButton(
                      onPressed: () async {
                        bool leave = await _handleBackNavigation();
                        if (leave) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LogScreen(),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) =>
                              states.contains(MaterialState.hovered)
                                  ? Colors.white
                                  : null,
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: const Text(
              "Error",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void showSuccess(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Success", style: TextStyle(color: Colors.green)),
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
