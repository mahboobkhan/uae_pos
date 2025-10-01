import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/designation_delete_provider.dart';
import '../../providers/update_salary_provider.dart';

class UpdateMonthlySalaryScreen extends StatefulWidget {
  const UpdateMonthlySalaryScreen({Key? key}) : super(key: key);

  @override
  State<UpdateMonthlySalaryScreen> createState() => _UpdateMonthlySalaryScreenState();
}

class _UpdateMonthlySalaryScreenState extends State<UpdateMonthlySalaryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _userIdController = TextEditingController();
  final _salaryMonthController = TextEditingController();
  final _advanceSalaryController = TextEditingController();
  final _bonusController = TextEditingController();
  final _fineDeductionController = TextEditingController();
  final _statusController = TextEditingController();

  Map<String, dynamic>? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _loadLastUpdated();
  }

  Future<void> _loadLastUpdated() async {
    final lastUpdated = await Provider.of<UpdateMonthlySalaryProvider>(context, listen: false)
        .getLastUpdatedSalary();
    setState(() {
      _lastUpdated = lastUpdated;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final request = UpdateMonthlySalaryRequest(
        userId: _userIdController.text.trim(),
        salaryMonth: _salaryMonthController.text.trim(),
        advanceSalary: double.tryParse(_advanceSalaryController.text.trim()) ?? 0.0,
        bonus: double.tryParse(_bonusController.text.trim()) ?? 0.0,
        fineDeduction: double.tryParse(_fineDeductionController.text.trim()) ?? 0.0,
        status: _statusController.text.trim(),
      );

      final provider = Provider.of<UpdateMonthlySalaryProvider>(context, listen: false);
      await provider.updateMonthlySalary(request);

      if (provider.state == RequestState.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Monthly salary updated successfully!")),
        );
        _loadLastUpdated();
      } else if (provider.state == RequestState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${provider.errorMessage}")),
        );
      }
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _salaryMonthController.dispose();
    _advanceSalaryController.dispose();
    _bonusController.dispose();
    _fineDeductionController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Monthly Salary")),
      body: Consumer<UpdateMonthlySalaryProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  if (_lastUpdated != null) ...[
                    Text(
                      "📌 Last updated salary:",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_lastUpdated.toString()),
                    const SizedBox(height: 20),
                  ],
                  TextFormField(
                    controller: _userIdController,
                    decoration: const InputDecoration(labelText: "User ID"),
                    validator: (v) => v == null || v.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _salaryMonthController,
                    decoration: const InputDecoration(labelText: "Salary Month (YYYY-MM)"),
                    validator: (v) => v == null || v.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _advanceSalaryController,
                    decoration: const InputDecoration(labelText: "Advance Salary"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _bonusController,
                    decoration: const InputDecoration(labelText: "Bonus"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _fineDeductionController,
                    decoration: const InputDecoration(labelText: "Fine Deduction"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _statusController,
                    decoration: const InputDecoration(labelText: "Status"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: provider.state == RequestState.loading ? null : _submit,
                    child: provider.state == RequestState.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Update Salary"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
