import 'package:abc_consultant/ui/screens/login%20screens/sign_up.dart';
import 'package:flutter/material.dart';

class TickForgotPassword extends StatefulWidget {
  const TickForgotPassword({super.key});

  @override
  State<TickForgotPassword> createState() => _TickForgotPasswordState();
}

class _TickForgotPasswordState extends State<TickForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Size(:height, :width) = size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/login_logo.png",
                height: height,
                width: width * 0.6,
                fit: BoxFit.fill,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width * 0.06),
                      //Text Forgot Password
                      Text(
                        "Request For Forgot Password",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: width * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width * 0.06),
                      //Text Send Request
                      Text(
                        "Sent request and submit verification code",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width * 0.06),
                      Text(
                        "CHECK MAIL BOX GET LINK AND RESET\nPASSWORD",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.01,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.05),
                  // Tick Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width * 0.05),
                      CircleAvatar(
                        radius: width * 0.025,
                        backgroundColor: Colors.green.shade600,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,

                          size: width * 0.045,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.07),
                  //Resend Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width * 0.05),
                      Center(
                        child: MaterialButton(
                          height: height * 0.07,
                          minWidth: width * 0.09,
                          onPressed: () {
                            //Resent Code Logic
                          },
                          color: Colors.red,
                          child: Text(
                            "Resent",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.12),
                  Row(
                    children: [
                      SizedBox(width: width * 0.06),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text("Create New Account? "),
                              Text(
                                "Signup",
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
