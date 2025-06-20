import 'package:abc_consultant/ui/screens/login%20screens/forgot_password_page.dart';
import 'package:abc_consultant/ui/screens/login%20screens/login_page.dart';
import 'package:abc_consultant/ui/screens/login%20screens/sign_up.dart';
import 'package:abc_consultant/ui/screens/login%20screens/tick_forgot_password.dart';
import 'package:abc_consultant/widgets/half_color_border.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Size(:height, :width) = size;
    return Scaffold(
      body: Row(
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
              SizedBox(height: height * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: width * 0.06),
                  Text(
                    "Request for Forgot Password",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.020,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              //Text send requwst'
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: width * 0.06),
                  Text(
                    "Sent Request and submit verification code",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: height * 0.05),
              //verify email feild
              Row(
                children: [
                  SizedBox(width: width * 0.035),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Verify Email Link From Email Box",
                        style: TextStyle(
                          fontSize: width * 0.010,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: height * 0.009),
                      SmoothGradientBorderContainer(
                        height: height * 0.05,
                        width: width * 0.15,
                        color: Colors.transparent,
                        child: TextFormField(
                          style: TextStyle(fontSize: 12),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "hello@reallygreatsite.com",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 17,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //Email Feild
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  SizedBox(width: width * 0.1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "RESENT ADMIN CODE VERIFICATION REQUEST",
                        style: TextStyle(
                          fontSize: width * 0.010,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: height * 0.009),
                      SmoothGradientBorderContainer(
                        height: height * 0.05,
                        width: width * 0.15,
                        color: Colors.transparent,
                        child: TextFormField(
                          style: TextStyle(fontSize: 12),
                          cursorHeight: height * 0.02,
                          decoration: const InputDecoration(
                            hintText: "346",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 17,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: width * 0.00),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 50),
                    child: Text(
                      "+1 234 567 (60s)",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),

              //Login Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: width * 0.055),
                  Center(
                    child: MaterialButton(
                      minWidth: width * 0.09,
                      height: height * 0.06,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    TickForgotPassword(),
                          ),
                        );
                      },
                      color: Colors.red,
                      child: Text(
                        "Sent Request",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
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
    );
  }
}
