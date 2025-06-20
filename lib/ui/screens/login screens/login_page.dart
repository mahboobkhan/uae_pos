import 'package:abc_consultant/ui/screens/login%20screens/forgot_password_page.dart';
import 'package:abc_consultant/ui/screens/login%20screens/login_page.dart';
import 'package:abc_consultant/ui/screens/login%20screens/sign_up.dart';
import 'package:abc_consultant/widgets/half_color_border.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  SizedBox(width: width * 0.1),
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.020,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              //Text sign in to COntinue'
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: width * 0.10),
                  Text(
                    "Sign in to continue",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: height * 0.05),
              //Email Feild
              Row(
                children: [
                  SizedBox(width: width * 0.1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
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
                        "Password",
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
                            hintText: "xxxxxxxxx",
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
                  SizedBox(width: width * 0.11),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Forgot/Update Password",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),

              //Login Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: width * 0.090),
                  Center(
                    child: MaterialButton(
                      minWidth: width * 0.09,
                      height: height * 0.06,
                      onPressed: () {},
                      color: Colors.red,
                      child: Text(
                        "Login",
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
                  SizedBox(width: width * 0.11),
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
