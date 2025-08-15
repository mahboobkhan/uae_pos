import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/create_salary_provider.dart';
import '../../providers/designation_delete_provider.dart';

class CreateMonthlySalaryScreen extends StatefulWidget {
  const CreateMonthlySalaryScreen({Key? key}) : super(key: key);

  @override
  State<CreateMonthlySalaryScreen> createState() =>
      _CreateMonthlySalaryScreenState();
}

class _CreateMonthlySalaryScreenState extends State<CreateMonthlySalaryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final _userIdController = TextEditingController();
  final _salaryMonthController = TextEditingController();
  final _advanceSalaryController = TextEditingController();
  final _bonusController = TextEditingController();
  final _fineDeductionController = TextEditingController();
  final _statusController = TextEditingController();

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

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final provider =
      Provider.of<CreateMonthlySalaryProvider>(context, listen: false);

      final request = CreateMonthlySalaryRequest(
        userId: _userIdController.text.trim(),
        salaryMonth: _salaryMonthController.text.trim(),
        advanceSalary: double.tryParse(_advanceSalaryController.text) ?? 0.0,
        bonus: double.tryParse(_bonusController.text) ?? 0.0,
        fineDeduction: double.tryParse(_fineDeductionController.text) ?? 0.0,
        status: _statusController.text.trim(),
      );

      provider.createMonthlySalary(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Monthly Salary"),
      ),
      body: Consumer<CreateMonthlySalaryProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _userIdController,
                    decoration: const InputDecoration(labelText: "User ID"),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _salaryMonthController,
                    decoration:
                    const InputDecoration(labelText: "Salary Month (YYYY-MM)"),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: _advanceSalaryController,
                    decoration:
                    const InputDecoration(labelText: "Advance Salary"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _bonusController,
                    decoration: const InputDecoration(labelText: "Bonus"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _fineDeductionController,
                    decoration:
                    const InputDecoration(labelText: "Fine Deduction"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _statusController,
                    decoration: const InputDecoration(labelText: "Status"),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: provider.state == RequestState.loading
                        ? null
                        : () => _submitForm(context),
                    child: provider.state == RequestState.loading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("Submit"),
                  ),
                  const SizedBox(height: 20),
                  if (provider.state == RequestState.error &&
                      provider.errorMessage != null)
                    Text(
                      "❌ ${provider.errorMessage}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (provider.state == RequestState.success)
                    const Text(
                      "✅ Salary created successfully!",
                      style: TextStyle(color: Colors.green),
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
