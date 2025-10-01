import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/create_employee_type_provider.dart';
import '../../providers/designation_delete_provider.dart';

class EmployeeTypeScreen extends StatefulWidget {
  const EmployeeTypeScreen({super.key});

  @override
  State<EmployeeTypeScreen> createState() => _EmployeeTypeScreenState();
}

class _EmployeeTypeScreenState extends State<EmployeeTypeScreen> {
  final TextEditingController _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load saved employee types on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
      Provider.of<EmployeeTypeProvider>(context, listen: false);
      provider.loadEmployeeTypes();
      provider.getSavedEmployeeType().then((savedType) {
        if (savedType != null) {
          provider.setEmployeeType(savedType);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Type"),
      ),
      body: Consumer<EmployeeTypeProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Dropdown for selecting employee type
                DropdownButtonFormField<String>(
                  value: provider.selectedEmployeeType,
                  hint: const Text("Select Employee Type"),
                  items: provider.employeeTypeList
                      .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      provider.setEmployeeType(value);
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Text field to add new employee type
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    labelText: "Add New Employee Type",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // Save button
                ElevatedButton(
                  onPressed: () {
                    if (_typeController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter an employee type")),
                      );
                      return;
                    }

                    provider.saveEmployeeType(
                      EmployeeTypeRequest(
                        userId: "123", // Replace with actual logged-in user ID
                        employeeType: _typeController.text.trim(),
                        createdBy: "admin", // Replace with actual creator name
                      ),
                    );
                  },
                  child: provider.state == RequestState.loading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Save Employee Type"),
                ),

                const SizedBox(height: 20),

                // Show error or success
                if (provider.state == RequestState.error &&
                    provider.errorMessage != null)
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (provider.state == RequestState.success)
                  const Text(
                    "✅ Employee Type Saved Successfully!",
                    style: TextStyle(color: Colors.green),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
