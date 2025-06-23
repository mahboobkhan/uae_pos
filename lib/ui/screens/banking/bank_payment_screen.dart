import 'package:abc_consultant/ui/dialogs/custom_dialoges.dart';
import 'package:flutter/material.dart';

class BankPaymentScreen extends StatelessWidget {
  const BankPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Payment Method",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "BID. 00001",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildInput(
                      "Select Platform",
                      hint: "Bank/Violet/Other Platform",
                    ),
                    _buildInput("Platform/Bank Name/Cash As Hand"),
                    _buildInput("Title Name"),
                    _buildInput("Account No"),
                    _buildInput("IBN"),
                    _buildInput("Email Id"),
                    _buildInput("Mobile Number"),
                    _buildInput("Tag Add"),
                    _buildInput(
                      "Bank Address Physical Address",
                      hint: "Address, Town, City, Postal Code, Country",
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: "Editing",
                      onPressed: () {},
                      backgroundColor: Colors.red,
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      text: "Submit",
                      onPressed: () {},
                      backgroundColor: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildInput(String label, {String? hint}) {
    return SizedBox(
      width: 230,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
