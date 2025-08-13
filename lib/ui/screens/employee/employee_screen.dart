import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/desigination_provider.dart';
import '../../../providers/signup_provider.dart';
import '../../../employee/EmployeeProvider.dart';
import '../../../employee/employee_models.dart';
import '../../dialogs/custom_dialoges.dart';
import '../../dialogs/tags_class.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  List<Map<String, dynamic>> tags = [];

  void _loadTags() async {
    final provider = Provider.of<SignupProvider>(context, listen: false);
    try {
      final result = await provider.getAllTags("user_123");
      setState(() {
        tags = result;
      });
    } catch (e) {
      print("Error loading tags: $e");
      // Optionally show a snackbar or alert
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTags();
    // Load employee data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false).getFullData();
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> currentTags = [
    {'tag': 'Tag1', 'color': Colors.green.shade100},
    {'tag': 'Tag2', 'color': Colors.orange.shade100},
  ];


  String? selectedCategory ='All';
  String? selectedCategory1= 'All';
  bool _isHovering = false;

  // Get unique employee types from the data
  List<String> getUniqueEmployeeTypes(EmployeeProvider provider) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      return ['All'];
    }
    
    final types = provider.employees!
        .map((e) => e.employeeType)
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList();
    
    return ['All', ...types];
  }

  // Get unique designations from the data
  List<String> getUniqueDesignations(EmployeeProvider provider) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      return ['All'];
    }
    
    final designations = provider.employees!
        .map((e) => e.empDesignation)
        .where((designation) => designation.isNotEmpty)
        .toSet()
        .toList();
    
    return ['All', ...designations];
  }

  // Get filtered employees based on selected filters
  List<Employee> getFilteredEmployees(EmployeeProvider provider) {
    if (provider.employees == null || provider.employees!.isEmpty) {
      return [];
    }

    return provider.employees!.where((employee) {
      // Filter by employee type
      if (selectedCategory != 'All' && employee.employeeType != selectedCategory) {
        return false;
      }
      
      // Filter by designation
      if (selectedCategory1 != 'All' && employee.empDesignation != selectedCategory1) {
        return false;
      }
      
      return true;
    }).toList();
  }

  String _formatDateForDisplay(String apiDate) {
    try {
      if (apiDate.isEmpty) return 'N/A';
      final parsedDate = DateTime.parse(apiDate);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow:
                        _isHovering
                            ? [
                              BoxShadow(
                                color: Colors.blue,
                                blurRadius: 4,
                                spreadRadius: 0.1,
                                offset: Offset(0, 1),
                              ),
                            ]
                            : [],
                  ),
                  child: Consumer<EmployeeProvider>(
                    builder: (context, employeeProvider, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  CustomDropdown(
                                    selectedValue: selectedCategory,
                                    hintText: "Employee Type",
                                    items: getUniqueEmployeeTypes(employeeProvider),
                                    onChanged: (newValue) {
                                      setState(() => selectedCategory = newValue!);
                                    },
                                  ),
                                  CustomDropdown(
                                    selectedValue: selectedCategory1,
                                    hintText: "Designation",
                                    items: getUniqueDesignations(employeeProvider),
                                    onChanged: (newValue) {
                                      setState(() => selectedCategory1 = newValue!);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 400,
                  child: Consumer<EmployeeProvider>(
                    builder: (context, employeeProvider, child) {
                      if (employeeProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (employeeProvider.employees == null || employeeProvider.employees!.isEmpty) {
                        return const Center(child: Text('No employees found'));
                      }

                      // Get filtered employees based on selected filters
                      final filteredEmployees = getFilteredEmployees(employeeProvider);
                      
                      if (filteredEmployees.isEmpty) {
                        return const Center(child: Text('No employees match the selected filters'));
                      }

                      return ScrollbarTheme(
                        data: ScrollbarThemeData(
                          thumbVisibility: MaterialStateProperty.all(true),
                          thumbColor: MaterialStateProperty.all(Colors.grey),
                          thickness: MaterialStateProperty.all(8),
                          radius: const Radius.circular(4),
                        ),
                        child: Scrollbar(
                          controller: _verticalController,
                          thumbVisibility: true,
                          child: Scrollbar(
                            controller: _horizontalController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _horizontalController,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                controller: _verticalController,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(minWidth: 1200),
                                  child: Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FlexColumnWidth(0.8),
                                      1: FlexColumnWidth(1.2),
                                      2: FlexColumnWidth(1.2),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1.5),
                                      5: FlexColumnWidth(1.3),
                                      6: FlexColumnWidth(1.3),
                                      7: FlexColumnWidth(1),
                                      8: FlexColumnWidth(1.5),
                                    },
                                    children: [
                                      // Header Row
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                        ),
                                        children: [
                                          _buildHeader("Date"),
                                          _buildHeader("Employee Detail "),
                                          _buildHeader("Tags Details"),
                                          _buildHeader("Designation"),
                                          _buildHeader("Payment Mode"),
                                          _buildHeader("Salary"),
                                          _buildHeader("Advance"),
                                          _buildHeader("Phone Number"),
                                        ],
                                      ),
                                      // Dynamic Data Rows
                                      ...filteredEmployees.map((employee) {
                                        final index = filteredEmployees.indexOf(employee);
                                        return TableRow(
                                          decoration: BoxDecoration(
                                            color: index.isEven
                                                ? Colors.grey.shade200
                                                : Colors.grey.shade100,
                                          ),
                                          children: [
                                            _buildCell2(_formatDateForDisplay(employee.lastUpdatedDate), "", centerText2: true),
                                            _buildCell(employee.employeeName),
                                            TagsCellWidget(initialTags: currentTags), // Using static tags as requested
                                            _buildCell(employee.empDesignation),
                                            _buildCell2(
                                                employee.paymentMethod.isEmpty ? "N/A" : employee.paymentMethod,
                                                ""
                                            ),

                                            _buildPriceWithAdd("AED-", employee.salary ?? "0"),
                                            _buildPriceWithAdd1(
                                              "AED-", 
                                              employee.salaryCurrentMonth?.advanceSalary ?? "0"
                                            ),
                                            _buildCell(employee.emirateId.isEmpty ? "N/A" : employee.emirateId),
                                          ],
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Table Widgets
  Widget _buildHeader(String text) => Container(
    height: 40,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 8.0),
    child: Text(
      text,
      style: const TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
    ),
  );

  Widget _buildCell3(String text1, String text2, {bool copyable = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text1, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text2,
                    style: const TextStyle(fontSize: 10, color: Colors.black54)),
                if (copyable)
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: "$text1\n$text2"));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(Icons.copy, size: 10, color: Colors.blue[700]),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );

  Widget _buildCell2(String text1, String text2,
      {bool copyable = false, bool centerText2 = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text1, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );

  Widget _buildCell(String text, {bool copyable = false}) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(text,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis),
        ),
        if (copyable)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.copy, size: 12, color: Colors.blue[700]),
            ),
          ),
      ],
    ),
  );

  Widget _buildPriceWithAdd(String curr, String price, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            curr,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(price,style: TextStyle(fontSize: 12,color: Colors.green,fontWeight: FontWeight.bold),),
          const Spacer(),
          if (showPlus)
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue),
              ),
              child: const Icon(Icons.add, size: 13, color: Colors.blue),
            ),
        ],
      ),
    );
  }
  Widget _buildPriceWithAdd1(String curr, String price, {bool showPlus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            curr,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(price,style: TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.bold),),
          const Spacer(),
          if (showPlus)
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue),
              ),
              child: const Icon(Icons.add, size: 13, color: Colors.blue),
            ),
        ],
      ),
    );
  }


}