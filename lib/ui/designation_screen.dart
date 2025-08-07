import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/desigination_provider.dart';
import '../utils/request_state.dart';

class DesignationScreen extends StatefulWidget {
  const DesignationScreen({super.key});

  @override
  State<DesignationScreen> createState() => _DesignationScreenState();
}

class _DesignationScreenState extends State<DesignationScreen> {
  String? selectedJobType;

  final List<String> jobOptions = [
    'Manager',
    'Employee',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Load saved designation
    Future.microtask(() =>
        context.read<DesignationProvider>().loadDesignation());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DesignationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Create Designation")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedJobType ?? (provider.getDesignation().isNotEmpty
                  ? provider.getDesignation()
                  : null),
              hint: const Text("Select Job Position"),
              items: jobOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedJobType = value;
                });
                provider.setDesignation(value!);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if ((selectedJobType ?? "").isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a designation")),
                  );
                  return;
                }

                provider.createDesignation(
                  DesignationRequest(
                    userId: "user_6888ecba5a626", // Replace with actual user id
                    designations: selectedJobType!,
                    createdBy: "admin_user",
                  ),
                );
              },
              child: const Text("Submit"),
            ),
            const SizedBox(height: 20),
            _buildStatusWidget(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusWidget(DesignationProvider provider) {
    switch (provider.state) {
      case RequestState.loading:
        return const CircularProgressIndicator();
      case RequestState.success:
        return const Text(
          "✅ Designation created successfully",
          style: TextStyle(color: Colors.green),
        );
      case RequestState.error:
        return Text(
          "❌ ${provider.errorMessage}",
          style: const TextStyle(color: Colors.red),
        );
      case RequestState.idle:
      default:
        return const SizedBox.shrink();
    }
  }
}
