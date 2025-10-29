import 'dart:async';
import 'package:abc_consultant/providers/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/loading_dialog.dart';
import '../../dialogs/custom_fields.dart';
import 'log_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String adminEmail;

  const VerificationScreen({super.key, required this.userId,
    required this.email,
    required this.adminEmail,});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _adminGmailController = TextEditingController();

  int _secondsRemaining = 60;
  bool _isCountdownRunning = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _isCountdownRunning = true;
      _secondsRemaining = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _isCountdownRunning = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (_isCountdownRunning) {
      return await _showExitConfirmationDialog();
    }
    return true;
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            content: const Text(" Are you sure you want to leave?"),
            actions: [
              TextButton(
                child: const Text("No",style: TextStyle(color: Colors.black),),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text("Yes",style: TextStyle(color: Colors.black),),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
    ) ??
        false;
  }



  @override
  void dispose() {
    _timer?.cancel();
    _gmailController.dispose();
    _adminGmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white12,
        body: Row(
          children: [
            Expanded(
              flex: 4,
              child: Image.asset("assets/login_logo.png", fit: BoxFit.cover),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Expanded(child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          'Verification Required',
                          style: TextStyle(
                            color: AppColors.redColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
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
                              suffixIcon: _isCountdownRunning
                                  ? const SizedBox()
                                  : TextButton(
                                onPressed: () async {
                                  // Step 1: Resend the verification PIN
                                  final resendError = await provider.resendVerificationPin(
                                    userId: widget.userId,
                                    to: "user", // or "user", or "both"
                                  );

                                  if (resendError != null) {
                                    showError(context, resendError);
                                    return;
                                  } else {
                                    _startCountdown();
                                    showSuccess(context, "Verification code resent successfully!");
                                  }
                                },
                                child: const Text(
                                  "Resend",
                                  style: TextStyle(fontSize: 10, color: Colors.blue),
                                ),
                              ),
                            ),
                            Text(
                              widget.email,
                              style: TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _adminGmailController,
                              label: 'Enter Code',
                              hintText: "00 00 00",
                              suffixIcon: _isCountdownRunning
                                  ? const SizedBox()
                                  : TextButton(
                                onPressed: () async {
                                  // Step 1: Resend the verification PIN
                                  final resendError = await provider.resendVerificationPin(
                                    userId: widget.userId,
                                    to: "admin", // or "user", or "both"
                                  );

                                  if (resendError != null) {
                                    showError(context, resendError);
                                    return;
                                  } else {
                                    _startCountdown();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Verification code resent successfully!"),
                                        backgroundColor: Colors.green, // Optional: Success color
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Resend",
                                  style: TextStyle(fontSize: 10, color: Colors.blue),
                                ),
                              ),
                            ),
                            Text(
                              widget.adminEmail,
                              style: TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            backgroundColor: AppColors.redColor,
                          ),
                          onPressed: () async {

                            {

                              // Step 2: Verify the user using entered PINs
                              final verifyError = await provider.verifyUser(
                                userId: widget.userId,
                                pinUser: _gmailController.text.trim(),
                                pinAdmin: _adminGmailController.text.trim(),
                              );

                              if (verifyError == null) {
                                // Verified successfully
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => LogScreen()),
                                );
                              } else {
                                showError(context, verifyError);
                              }
                            };
                            showLoadingDialog(context);

                            final error = await provider.verifyUser(
                              userId: widget.userId,
                              pinUser:_gmailController.text.trim(),
                              pinAdmin: _adminGmailController.text.trim(),
                            );
                            hideLoadingDialog(context);

                            if (error == null) {
                              // Verified successfully
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => LogScreen()),
                              );
                            } else {
                              showError(context, error);
                            }
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_secondsRemaining > 0)
                          Text(
                            "$_secondsRemaining - Seconds",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  )),
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LogScreen()),
                      );                    },
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
      ),
    );
  }
  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
        title: const Text("Verification failed "),
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
  void showSuccess(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
