import 'package:abc_consultant/ui/screens/SidebarLayout.dart';
import 'package:abc_consultant/ui/screens/client_screen/company_screen.dart';
import 'package:abc_consultant/ui/screens/login%20screens/login_page.dart';
import 'package:abc_consultant/ui/screens/login%20screens/new_account_verification.dart';
import 'package:abc_consultant/ui/screens/login%20screens/tick_forgot_password.dart';
import 'package:abc_consultant/ui/screens/login%20screens/track_order.dart';

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
    return MaterialApp(home: LoginPage());
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
