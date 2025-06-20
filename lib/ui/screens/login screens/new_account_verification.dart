import 'package:abc_consultant/ui/screens/login%20screens/forgot_password_page.dart';
import 'package:abc_consultant/ui/screens/login%20screens/login_page.dart';
import 'package:abc_consultant/ui/screens/login%20screens/sign_up.dart';
import 'package:abc_consultant/widgets/half_color_border.dart';
import 'package:flutter/material.dart';

class NewAccountVerificationScreen extends StatefulWidget {
  const NewAccountVerificationScreen({super.key});

  @override
  State<NewAccountVerificationScreen> createState() =>
      _NewAccountVerificationScreenState();
}

class _NewAccountVerificationScreenState
    extends State<NewAccountVerificationScreen> {
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
                    "Verification Required",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.020,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),

              SizedBox(height: height * 0.05),
              //Name Feild
              Row(
                children: [
                  SizedBox(width: width * 0.09),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
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
                            hintText: "Jiara Martins",
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
              //verify email link drom email box
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  SizedBox(width: width * 0.1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Verify Email LInk From Email Box ()",
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
                            hintText: "hello@greatsite.com",
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
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  SizedBox(width: width * 0.11),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sent Admin Verification Code Request",
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
                            hintText: "3456",
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
                    padding: const EdgeInsets.only(top: 8, left: 19),
                    child: Text(
                      "+1 234 567 (60s)",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.05),

              //Submit Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: width * 0.085),
                  Center(
                    child: MaterialButton(
                      minWidth: width * 0.09,
                      height: height * 0.06,
                      onPressed: () {},
                      color: Colors.red,
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: width * 0.08),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "60 - Seconds",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: width * 0.072),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 19),
                    child: Text(
                      "Resend 2-steps code",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.12),

              Row(
                children: [
                  SizedBox(width: width * 0.1),
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
                          InkWell(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => LoginPage(),
                                  ),
                                ),
                            child: const Text("Already Registered "),
                          ),
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
