import 'dart:async';
import 'package:flutter/material.dart';
import 'package:abc_consultant/ui/screens/login%20screens/create_new_password.dart';
import 'package:abc_consultant/ui/screens/login%20screens/log_screen.dart';
import '../../dialogs/custom_fields.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _adminGmailController = TextEditingController();

  int countdown = 4;
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
      countdown = 4;
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
              content: const Text(" Are you sure you want to leave?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Yes"),
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
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Admin Code
                              CustomTextField(
                                controller: _adminGmailController,
                                label: 'Enter Code',
                                hintText: "00 00 00",
                                suffixIcon:
                                    isCountdownRunning
                                        ? const SizedBox()
                                        : TextButton(
                                          onPressed: startCountdown,
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
                                'user@email.com',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 20),
                              /// User Code
                              CustomTextField(
                                controller: _gmailController,
                                label: 'Enter Code',
                                hintText: "00 00 00",
                                suffixIcon:
                                    isCountdownRunning
                                        ? const SizedBox()
                                        : TextButton(
                                          onPressed: startCountdown,
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
                                'admin@email.com',
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
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const CreateNewPassword(),
                                ),
                              );
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
}
