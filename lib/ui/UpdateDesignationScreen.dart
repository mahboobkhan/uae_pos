import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/update_designation.dart';
import '../utils/request_state.dart';

class UpdateDesignationScreen extends StatefulWidget {
  final int employeeId; // ← ID pass karo jab screen open karo

  const UpdateDesignationScreen({
    super.key,
    required this.employeeId,
  });

  @override
  State<UpdateDesignationScreen> createState() => _UpdateDesignationScreenState();
}

class _UpdateDesignationScreenState extends State<UpdateDesignationScreen> {
  String? selectedDesignation;

  /// Example dropdown options (later API se fetch ho sakta hai)
  final List<String> designationOptions = [
    "Manager",
    "Employee",
    "Team Lead",
    "Project Manager",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DesignationUpdateProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Update Designation")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedDesignation,
              hint: const Text("Select New Designation"),
              items: designationOptions.map((d) {
                return DropdownMenuItem(value: d, child: Text(d));
              }).toList(),
              onChanged: (value) => setState(() => selectedDesignation = value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "New Designation",
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.update),
                label: const Text("Update"),
                onPressed: provider.state == RequestState.loading
                    ? null
                    : () => _onUpdatePressed(context),
              ),
            ),

            const SizedBox(height: 10),

            if (provider.state == RequestState.loading)
              const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> _onUpdatePressed(BuildContext context) async {
    final provider = context.read<DesignationUpdateProvider>();

    if ((selectedDesignation ?? "").isEmpty) {
      _showDialog(context, "Error", "Please select a new designation");
      return;
    }

    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Call API with ID + New Designation
    await provider.updateDesignation(
      widget.employeeId, // ID pass ho raha hai
      selectedDesignation!,
    );

    if (Navigator.canPop(context)) Navigator.pop(context); // Close loading

    // Show result
    if (provider.state == RequestState.success) {
      _showDialog(context, "Success", "Designation updated successfully");
    } else {
      _showDialog(context, "Error", provider.errorMessage ?? "Something went wrong");
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: title == "Success" ? Colors.green : Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
