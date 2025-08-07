import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/designation_list_provider.dart';
import '../utils/request_state.dart';

class DesignationListScreen extends StatefulWidget {
  const DesignationListScreen({super.key});

  @override
  State<DesignationListScreen> createState() => _DesignationListScreenState();
}

class _DesignationListScreenState extends State<DesignationListScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<DesignationListProvider>();

    // Pehle locally saved data load karo
    provider.loadSavedDesignations();

    // Fir fresh data API se fetch karo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchDesignations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DesignationListProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Designation List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.fetchDesignations(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchDesignations(),
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(DesignationListProvider provider) {
    if (provider.state == RequestState.loading && provider.designations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.state == RequestState.error && provider.designations.isEmpty) {
      return Center(
        child: Text(
          provider.errorMessage ?? "Failed to load designations",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (provider.designations.isEmpty) {
      return const Center(child: Text("No designations found"));
    }

    return ListView.separated(
      itemCount: provider.designations.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = provider.designations[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(item.id.toString()),
          ),
          title: Text(item.designations),
          subtitle: Text("Created by: ${item.createdBy}"),
          trailing: Text(item.createdDate),
        );
      },
    );
  }
}
