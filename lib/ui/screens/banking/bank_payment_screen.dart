import 'package:flutter/material.dart';

class BankPaymentScreen extends StatelessWidget {
  const BankPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Payment Method",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Text(
              "BID. 00001",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildInput("Select Platform", hint: "Bank/Violet/Other Platform"),
                _buildInput("Platform/Bank Name/Cash As Hand"),
                _buildInput("Title Name"),
                _buildInput("Account No"),
                _buildInput("IBN"),
                _buildInput("Email Id"),
                _buildInput("Mobile Number"),
                _buildInput("Tag Add"),
                _buildInput("Bank Address Physical Address",
                    hint: "Address, Town, City, Postal Code, Country"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: const Text("Editing", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: const Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  static Widget _buildInput(String label, {String? hint}) {
    return SizedBox(
      width: 210,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.red),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

}
