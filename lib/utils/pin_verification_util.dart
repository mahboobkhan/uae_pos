import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_colors.dart';

class PinVerificationUtil {
  /// Show PIN verification dialog before allowing any edit action
  static Future<bool> showPinVerificationDialog(
    BuildContext context, {
    String title = "Edit Verification",
    String message = "Please enter your PIN to confirm this action",
  }) async {
    final TextEditingController verificationController = TextEditingController();
    
    // Get the saved PIN from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('pin') ?? '1234'; // Default fallback

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: verificationController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, letterSpacing: 8),
                  decoration: const InputDecoration(
                    labelText: 'PIN',
                    hintText: '',
                    border: OutlineInputBorder(),
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 4) {
                      // Auto-verify when 4 digits are entered
                      if (value == savedPin) {
                        Navigator.of(context).pop(true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid PIN. Please try again."),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        verificationController.clear();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                final enteredCode = verificationController.text.trim();
                if (enteredCode == savedPin) {
                  Navigator.of(context).pop(true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid PIN. Please try again."),
                      backgroundColor: AppColors.redColor,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  verificationController.clear();
                }
              },
              child: const Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ) ?? false; // Return false if dialog is dismissed
  }

  /// Wrapper function to execute any action after PIN verification
  static Future<void> executeWithPinVerification(
    BuildContext context,
    VoidCallback action, {
    String title = "Action Verification",
    String message = "Please enter your PIN to confirm this action",
  }) async {
    final isVerified = await showPinVerificationDialog(
      context,
      title: title,
      message: message,
    );
    
    if (isVerified) {
      action();
    }
  }
}