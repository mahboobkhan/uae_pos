import 'package:abc_consultant/ui/screens/login%20screens/login_page.dart';
import 'package:abc_consultant/widgets/half_color_border.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                    "Create New Account",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.020,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.04),
              //Name Feild
              Row(
                children: [
                  SizedBox(width: width * 0.1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          fontSize: width * 0.012,
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
                            hintText: "Jiara Martins",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 19,
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
                        "Email",
                        style: TextStyle(
                          fontSize: width * 0.012,
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
                            hintText: "hello@reallygreatesite.com",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 19,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              //Password Feild
              Row(
                children: [
                  SizedBox(width: width * 0.1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: width * 0.012,
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
                            hintText: "xxxxxxxx",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 19,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              //Confirm Password Feild
              Row(
                children: [
                  SizedBox(width: width * 0.1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Confirm Password",
                        style: TextStyle(
                          fontSize: width * 0.012,
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
                            hintText: "xxxxxxxx",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              bottom: 19,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //SignUP Button
              SizedBox(height: height * 0.05),
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
                        "Sign Up",
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
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("Already Registered? "),
                          Text(
                            "Login",
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
