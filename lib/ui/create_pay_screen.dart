import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/create_payment_method_provider.dart';
import '../utils/request_state.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedMethod;

  /// Example options — replace with API-driven list if available
  final List<String> paymentOptions = [
    "Cash",
    "Bank Transfer",
    "Credit Card",
    "PayPal",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedMethod();
  }

  Future<void> _loadSavedMethod() async {
    final provider = context.read<PaymentMethodProvider>();
    final saved = await provider.getSavedPaymentMethod();
    setState(() => selectedMethod = saved);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentMethodProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Select Payment Method")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedMethod,
              hint: const Text("Choose Payment Method"),
              items: paymentOptions.map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedMethod = value);
                provider.setPaymentMethod(value!);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Payment Method",
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save"),
                onPressed: provider.state == RequestState.loading
                    ? null
                    : () => _onSavePressed(context),
              ),
            ),
            if (provider.state == RequestState.loading) ...[
              const SizedBox(height: 10),
              const LinearProgressIndicator(),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> _onSavePressed(BuildContext context) async {
    final provider = context.read<PaymentMethodProvider>();

    if ((selectedMethod ?? "").isEmpty) {
      _showMessageDialog(context, "Error", "Please select a payment method");
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await provider.savePaymentMethod(
      PaymentMethodRequest(
        userId: "user_001", // Replace with actual logged-in user ID
        paymentMethod: selectedMethod!,
        createdBy: "admin", // Replace with actual creator
      ),
    );

    if (Navigator.canPop(context)) Navigator.pop(context); // Close loading

    if (provider.state == RequestState.success) {
      _showMessageDialog(context, "Success", "Payment method saved successfully");
    } else {
      _showMessageDialog(context, "Error", provider.errorMessage ?? "Something went wrong");
    }
  }

  void _showMessageDialog(BuildContext context, String title, String message) {
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
