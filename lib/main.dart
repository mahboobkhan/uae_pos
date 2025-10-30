import 'package:abc_consultant/providers/banking_payment_method_provider.dart';
import 'package:abc_consultant/providers/banking_payments_provider.dart';
import 'package:abc_consultant/providers/client_organization_employee_provider.dart';
import 'package:abc_consultant/providers/client_profile_provider.dart';
import 'package:abc_consultant/providers/create_bank_account.dart';
import 'package:abc_consultant/providers/create_bank_provider.dart';
import 'package:abc_consultant/providers/create_employee_type_provider.dart';
import 'package:abc_consultant/providers/create_payment_method_provider.dart';
import 'package:abc_consultant/providers/create_salary_provider.dart';
import 'package:abc_consultant/providers/dashboard_provider.dart';
import 'package:abc_consultant/providers/delete_bank_account.dart';
import 'package:abc_consultant/providers/desigination_provider.dart';
import 'package:abc_consultant/providers/designation_delete_provider.dart';
import 'package:abc_consultant/providers/designation_list_provider.dart';
import 'package:abc_consultant/providers/documents_provider.dart';
import 'package:abc_consultant/providers/employee_payments_provider.dart';
import 'package:abc_consultant/providers/links_provider.dart';
import 'package:abc_consultant/providers/project_stage_provider.dart';
import 'package:abc_consultant/providers/projects_provider.dart';
import 'package:abc_consultant/providers/project_report_provider.dart';
import 'package:abc_consultant/providers/service_category_provider.dart';
import 'package:abc_consultant/providers/short_service_category_provider.dart';
import 'package:abc_consultant/providers/short_service_invoice_provider.dart';
import 'package:abc_consultant/providers/short_services_provider.dart';
import 'package:abc_consultant/providers/signup_provider.dart';
import 'package:abc_consultant/providers/update_ban_account_provider.dart';
import 'package:abc_consultant/providers/update_designation.dart';
import 'package:abc_consultant/providers/update_password_provider.dart';
import 'package:abc_consultant/ui/screens/login%20screens/log_screen.dart';
import 'package:abc_consultant/ui/screens/projects/create_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'employee/EmployeeProvider.dart';
import 'providers/expense_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ✅ Pehle provider ka object banao
  final designationProvider = DesignationProvider();

  /// ✅ Saved value load karo
  await designationProvider.loadDesignation();
  // Needed for plugins like shared_preferences
  await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => UpdateUserBankAccountProvider()),
        ChangeNotifierProvider(create: (_) => DesignationProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DesignationUpdateProvider()),
        ChangeNotifierProvider(create: (_) => DesignationDeleteProvider()),
        ChangeNotifierProvider(create: (_) => DesignationListProvider()),
        ChangeNotifierProvider(create: (_) => CreateMonthlySalaryProvider()),
        ChangeNotifierProvider(create: (_) => CreateUserBankAccountProvider()),
        ChangeNotifierProvider(create: (_) => PaymentMethodProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeTypeProvider()),
        ChangeNotifierProvider(create: (_) => BankCreateProvider()),
        ChangeNotifierProvider(create: (_) => DeleteUserBankAccountProvider()),
        ChangeNotifierProvider(create: (_) => UpdatePasswordProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => ServiceCategoryProvider()),
        ChangeNotifierProvider(create: (_) => ShortServicesProvider()),
        ChangeNotifierProvider(create: (_) => ShortServiceInvoiceProvider()),
        ChangeNotifierProvider(create: (_) => ProjectsProvider()),
        ChangeNotifierProvider(create: (_) => ProjectStageProvider()),
        ChangeNotifierProvider(create: (_) => ProjectReportProvider()),
        ChangeNotifierProvider(create: (_) => ClientProfileProvider()),
        ChangeNotifierProvider(create: (_) => ClientOrganizationEmployeeProvider()),
        ChangeNotifierProvider(create: (_) => DocumentsProvider()),
        ChangeNotifierProvider(create: (_) => BankingPaymentMethodProvider()),
        ChangeNotifierProvider(create: (_) => BankingPaymentsProvider()),
        ChangeNotifierProvider(create: (_) => ShortServiceCategoryProvider()),
        ChangeNotifierProvider(create: (_) => EmployeePaymentsProvider()),
        ChangeNotifierProvider(create: (_) => LinksProvider()),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.red.withOpacity(0.4),
          cursorColor: Colors.black,
          selectionHandleColor: Colors.red,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LogScreen(),
    );
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
