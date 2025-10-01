import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/client_organization_employee_provider.dart';
import 'add_employee_dialog.dart';
import 'custom_fields.dart';

Future<void> showEmployeeListDialog(BuildContext context, {required String clientRefId, required String clientName}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: EmployeeListDialog(clientRefId: clientRefId, clientName: clientName),
        ),
  );
}

class EmployeeListDialog extends StatefulWidget {
  final String clientRefId;
  final String clientName;

  const EmployeeListDialog({super.key, required this.clientRefId, required this.clientName});

  @override
  State<EmployeeListDialog> createState() => _EmployeeListDialogState();
}

class _EmployeeListDialogState extends State<EmployeeListDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final provider = context.read<ClientOrganizationEmployeeProvider>();
        provider.getAllEmployees(clientRefId: widget.clientRefId);
      } catch (e) {
        // ignore provider lookup errors on early build
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 900,
        height: 600,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Employees - ${widget.clientName}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                      Text('Client Ref: ${widget.clientRefId}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await showAddEmployeeDialog(context, clientRefId: widget.clientRefId);
                          // Refresh the list after adding
                          if (mounted) {
                            context.read<ClientOrganizationEmployeeProvider>().getAllEmployees(clientRefId: widget.clientRefId);
                          }
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Employee'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () => Navigator.of(context).pop()),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Consumer<ClientOrganizationEmployeeProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(provider.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16), textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              provider.clearMessages();
                              provider.getAllEmployees(clientRefId: widget.clientRefId);
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.employees.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No employees found', style: TextStyle(color: Colors.grey, fontSize: 16)),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await showAddEmployeeDialog(context, clientRefId: widget.clientRefId);
                              // Refresh the list after adding
                              if (mounted) {
                                provider.getAllEmployees(clientRefId: widget.clientRefId);
                              }
                            },
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Add First Employee'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                      columns: const [
                        DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Emirates ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Work Permit', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Contact', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Created', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows:
                          provider.employees.map((employee) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(employee['type']).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: _getTypeColor(employee['type'])),
                                    ),
                                    child: Text(
                                      employee['type'] ?? 'N/A',
                                      style: TextStyle(color: _getTypeColor(employee['type']), fontWeight: FontWeight.w500, fontSize: 12),
                                    ),
                                  ),
                                ),
                                DataCell(Text(employee['name'] ?? 'N/A')),
                                DataCell(Text(employee['emirate_id'] ?? 'N/A')),
                                DataCell(Text(employee['work_permit_no'] ?? 'N/A')),
                                DataCell(Text(employee['email'] ?? 'N/A')),
                                DataCell(Text(employee['contact_no'] ?? 'N/A')),
                                DataCell(Text(_formatDate(employee['created_at']))),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
                                        onPressed: () async {
                                          await showAddEmployeeDialog(context, clientRefId: widget.clientRefId, employeeData: employee);
                                          // Refresh the list after editing
                                          if (mounted) {
                                            provider.getAllEmployees(clientRefId: widget.clientRefId);
                                          }
                                        },
                                        tooltip: 'Edit Employee',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                                        onPressed: () async {
                                          final shouldDelete = await showDialog<bool>(
                                            context: context,
                                            builder:
                                                (context) => const ConfirmationDialog(
                                                  title: 'Confirm Deletion',
                                                  content: 'Are you sure you want to delete this employee?',
                                                  cancelText: 'Cancel',
                                                  confirmText: 'Delete',
                                                ),
                                          );

                                          if (shouldDelete == true) {
                                            await provider.deleteEmployee(employeeRefId: employee['employee_ref_id']);
                                          }
                                        },
                                        tooltip: 'Delete Employee',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _capText(String? value, {double maxWidth = 200, int maxLines = 1}) {
    final text = (value == null || value.isEmpty) ? 'N/A' : value;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Tooltip(
        message: text, // full text on hover
        waitDuration: const Duration(milliseconds: 400),
        child: Text(text, maxLines: maxLines, overflow: TextOverflow.ellipsis, softWrap: false),
      ),
    );
  }

  Color _getTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'employee':
        return Colors.blue;
      case 'partner':
        return Colors.green;
      case 'other':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }
}
