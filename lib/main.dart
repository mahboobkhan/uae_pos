import 'package:abc_consultant/ui/screens/SidebarLayout.dart';
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
    return MaterialApp(home: SidebarLayout());
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
