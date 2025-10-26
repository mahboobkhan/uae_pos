import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/client_organization_employee_provider.dart';
import 'add_relations_dialog.dart';

Future<void> showRelationsListDialog(
  BuildContext context, {
  required String clientRefId,
  required String clientName,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: RelationsListDialog(clientRefId: clientRefId, clientName: clientName),
    ),
  );
}

class RelationsListDialog extends StatefulWidget {
  final String clientRefId;
  final String clientName;

  const RelationsListDialog({super.key, required this.clientRefId, required this.clientName});

  @override
  State<RelationsListDialog> createState() => _RelationsListDialogState();
}

class _RelationsListDialogState extends State<RelationsListDialog> {
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
        width: 800,
        height: 600,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Relations Management',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      Text(
                        'Client: ${widget.clientName}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person_add, color: Colors.orange),
                        tooltip: 'Add Relation',
                        onPressed: () async {
                          await showAddRelationsDialog(
                            context,
                            clientRefId: widget.clientRefId,
                          );
                          // Refresh the list after adding
                          if (mounted) {
                            context.read<ClientOrganizationEmployeeProvider>().getAllEmployees(clientRefId: widget.clientRefId);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
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
                          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                          const SizedBox(height: 16),
                          Text(
                            provider.errorMessage!,
                            style: TextStyle(color: Colors.red.shade600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => provider.getAllEmployees(clientRefId: widget.clientRefId),
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
                          Icon(Icons.family_restroom, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'No relations found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add relations for this individual client',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await showAddRelationsDialog(
                                context,
                                clientRefId: widget.clientRefId,
                              );
                              // Refresh the list after adding
                              if (mounted) {
                                provider.getAllEmployees(clientRefId: widget.clientRefId);
                              }
                            },
                            icon: const Icon(Icons.person_add),
                            label: const Text('Add First Relation'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.employees.length,
                    itemBuilder: (context, index) {
                      final relation = provider.employees[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.shade100,
                            child: Icon(Icons.person, color: Colors.orange.shade700),
                          ),
                          title: Text(
                            relation['name'] ?? 'Unknown Relation',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (relation['type'] != null)
                                Text('Type: ${relation['type']}'),
                              if (relation['email'] != null)
                                Text('Email: ${relation['email']}'),
                              if (relation['contact_no'] != null)
                                Text('Contact: ${relation['contact_no']}'),
                              if (relation['status'] != null)
                                Text('Status: ${relation['status']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Edit Relation',
                                onPressed: () async {
                                  await showAddRelationsDialog(
                                    context,
                                    clientRefId: widget.clientRefId,
                                    relationData: relation,
                                  );
                                  // Refresh the list after editing
                                  if (mounted) {
                                    provider.getAllEmployees(clientRefId: widget.clientRefId);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete Relation',
                                onPressed: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text('Are you sure you want to delete this relation?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                  
                                  if (shouldDelete == true && relation['employee_ref_id'] != null) {
                                    await provider.deleteEmployee(employeeRefId: relation['employee_ref_id']);
                                    if (mounted) {
                                      provider.getAllEmployees(clientRefId: widget.clientRefId);
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
