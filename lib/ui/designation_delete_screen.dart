import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/designation_delete_provider.dart';

class DesignationDeleteScreen extends StatelessWidget {
  const DesignationDeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DesignationDeleteProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Designations")),
      body: provider.getDesignations().isEmpty
          ? const Center(child: Text("No designations available"))
          : ListView.builder(
        itemCount: provider.getDesignations().length,
        itemBuilder: (context, index) {
          final designation = provider.getDesignations()[index];
          return ListTile(
            title: Text(designation),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _confirmDelete(context, designation);
              },
            ),
          );
        },
      ),
    );
  }

  /// Show confirmation before deleting
  void _confirmDelete(BuildContext context, String designation) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '$designation'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context); // Close confirmation dialog
              _deleteDesignation(context, designation);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  /// Perform deletion
  void _deleteDesignation(BuildContext context, String designation) async {
    final provider = context.read<DesignationDeleteProvider>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Call provider method
    await provider.deleteDesignation(
      DesignationDeleteRequest(designations: designation),
    );

    // Close loading dialog
    Navigator.pop(context);

    // Show result dialog
    if (provider.state == RequestState.success) {
      _showMessageDialog(context, "Success", "Designation deleted successfully");
    } else {
      _showMessageDialog(
        context,
        "Error",
        provider.errorMessage ?? "Something went wrong",
      );
    }
  }

  /// Reusable message dialog
  void _showMessageDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: title.toLowerCase() == "success" ? Colors.green : Colors.red,
          ),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
