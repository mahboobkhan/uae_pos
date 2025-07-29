import 'package:abc_consultant/providers/signup_provider.dart';
import 'package:abc_consultant/ui/screens/SidebarLayout.dart';
import 'package:abc_consultant/ui/screens/dashboard/employees_role_screen.dart';
import 'package:abc_consultant/ui/screens/login%20screens/create_new_password.dart';
import 'package:abc_consultant/ui/screens/login%20screens/forgot_screen.dart';
import 'package:abc_consultant/ui/screens/login%20screens/log_screen.dart';
import 'package:abc_consultant/ui/screens/login%20screens/sign_screen.dart';
import 'package:abc_consultant/ui/screens/login%20screens/verification_screen.dart';
import 'package:abc_consultant/ui/screens/projects/create_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Needed for plugins like shared_preferences
  await SharedPreferences.getInstance();


  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SignupProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    //  return MaterialApp(home: DashboardScrn());
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:SidebarLayout());
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
