import 'package:abc_consultant/ui/screens/SidebarLayout.dart';
import 'package:abc_consultant/ui/screens/login%20screens/create_new_password.dart';
import 'package:abc_consultant/ui/screens/login%20screens/forgot_password_page.dart';
import 'package:abc_consultant/ui/screens/login%20screens/login_page.dart';
import 'package:abc_consultant/ui/screens/login%20screens/new_account_verification.dart';
import 'package:abc_consultant/ui/screens/login%20screens/sign_up.dart';
import 'package:abc_consultant/ui/screens/office/dialogues/dialogue_fixed_office_expense.dart';
import 'package:abc_consultant/ui/screens/office/fixed_office_expense.dart';
import 'package:abc_consultant/ui/screens/office/office_expense_screen.dart';
import 'package:abc_consultant/ui/screens/projects/client_screen/comapny_profile_add.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  return MaterialApp(home: DashboardScrn());
    return MaterialApp(home: CreateNewPassword());
    //home: SidebarLayout()
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
