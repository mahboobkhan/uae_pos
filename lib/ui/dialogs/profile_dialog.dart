import 'package:abc_consultant/employee/EmployeeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/update_password_provider.dart';
import '../../providers/update_pin_provider.dart';

void showProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 4,
        backgroundColor: Colors.transparent,
        child: FutureBuilder<Map<String, String>>(
          future: _loadUserFromPrefs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Error loading data"),
              );
            } else {
              return _buildDialogContent(context, snapshot.data!);
            }
          },
        ),
      );
    },
  );
}

Future<Map<String, String>> _loadUserFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('user_id') ?? '';

  // Try to get employee data for phone number
  String phoneNumber = prefs.getString('phone') ?? '';

  return {
    'user_id': userId,
    'name': prefs.getString('name') ?? '',
    'email': prefs.getString('email') ?? '',
    'password': prefs.getString('password') ?? '',
    'pin': prefs.getString('pin') ?? '',
    'phone': phoneNumber,
  };
}

Widget _buildDialogContent(BuildContext context, Map<String, String> user) {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.topCenter,
    children: [
      Container(
        width: 350,
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.only(
          top: 60,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Consumer<EmployeeProvider>(
          builder: (context, employeeProvider, child) {
            // Get employee data for phone number
            final employee = employeeProvider.getEmployeeByUserId(
              user['user_id'] ?? '',
            );
            final phoneNumber = employee?.personalPhone ?? user['phone'] ?? '-';

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user['name']?.toString() ?? '-',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(thickness: 1),
                _InfoRow(
                  label: 'Email',
                  value: user['email']?.toString() ?? '-',
                ),
                GestureDetector(
                  onTap: () => (context, phoneNumber),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoRow(label: 'Phone', value: phoneNumber),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                _DialogButton(
                  label: '',
                  hint: user['password']?.toString() ?? '-',
                  showEdit: true,
                  onEditTap: () => showEditDialog(context),
                ),
                // Add helpful hint for password issues
                if (user['password']?.isEmpty == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Note: If you cannot change your password, please log out and log in again.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange[700],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 8),
                _DialogButton(
                  label: '',
                  hint: user['pin']?.toString() ?? '-',
                  showEdit: true,
                  onEditTap: () => showEditDialog1(context),
                ),
                const SizedBox(height: 8),
                // Add a refresh button to reload user data
                TextButton.icon(
                  onPressed: () async {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile data refreshed')),
                    );

                    // Rebuild the dialog with fresh data
                    Navigator.of(context).pop();
                    showProfileDialog(context);
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh Profile Data'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
                // labelWithArrow('Finance History'),
              ],
            );
          },
        ),
      ),

      // Circle Avatar
      Positioned(
        top: 0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.red,
              child: Icon(Icons.person, color: Colors.white, size: 50),
            ),
           /* Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),*/
          ],
        ),
      ),

     /* // Info icon
      Positioned(
        top: 55,
        right: 20,
        child: CustomPopup(
          content: const Text('The image size is 12mb'),
          child: const Icon(Icons.error_outline, size: 20, color: Colors.red),
        ),
      ),*/
    ],
  );
}

Widget labelWithArrow(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(color: Colors.black, fontSize: 16)),
        const Icon(
          Icons.chevron_right, // Greater than-style arrow
          color: Colors.black54,
          size: 20,
        ),
      ],
    ),
  );
}

class _DialogButton extends StatefulWidget {
  final String label;
  final String? hint;
  final bool showEdit;
  final VoidCallback? onEditTap;

  const _DialogButton({
    required this.label,
    this.hint,
    this.showEdit = false,
    this.onEditTap,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
  bool _obscure = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final realText = widget.hint ?? '';
    _controller = TextEditingController(
      text: _obscure ? _maskPassword(realText) : realText,
    );
  }

  @override
  void didUpdateWidget(_DialogButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller when hint changes
    if (oldWidget.hint != widget.hint) {
      final realText = widget.hint ?? '';
      _controller.text = _obscure ? _maskPassword(realText) : realText;
    }
  }

  String _maskPassword(String text) => '*' * text.length;

  void _toggleObscure() {
    final realText = widget.hint ?? '';
    setState(() {
      _obscure = !_obscure;
      _controller.text = _obscure ? _maskPassword(realText) : realText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.showEdit
        ? Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                readOnly: true,
                enableInteractiveSelection: false,
                style: const TextStyle(letterSpacing: 2),
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  isDense: true,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 18,
                        ),
                        onPressed: _toggleObscure,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.green,
                          size: 18,
                        ),
                        onPressed: widget.onEditTap, // 👈 call passed dialog
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
        : const SizedBox();
  }
}

class EditableDialogButton extends StatefulWidget {
  final String label;
  final String? hint;
  final bool showEdit;
  final TextEditingController? controller;

  const EditableDialogButton({
    super.key,
    required this.label,
    this.hint,
    this.showEdit = false,
    this.controller,
  });

  @override
  State<EditableDialogButton> createState() => _EditableDialogButtonState();
}

class _EditableDialogButtonState extends State<EditableDialogButton> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.hint ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showEdit) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: widget.label,
          ),
        ),
      );
    } else {
      return ListTile(
        title: Text(widget.label),
        subtitle: widget.hint != null ? Text(widget.hint!) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      );
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}

void showEditDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return ChangeNotifierProvider(
        create: (context) => UpdatePasswordProvider(),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          backgroundColor: Colors.white,
          child: _buildEdit(context),
        ),
      );
    },
  );
}

Widget _buildEdit(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      final currentPasswordController = TextEditingController();
      final newPasswordController = TextEditingController();
      final confirmPasswordController = TextEditingController();

      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 350,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),

                Text(
                  'Change Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                EditableDialogButton(
                  label: 'Current Password',
                  hint: '',
                  showEdit: true,
                  controller: currentPasswordController,
                ),
                // New PIN TextField
                EditableDialogButton(
                  label: 'New Password',
                  hint: '',
                  showEdit: true,
                  controller: newPasswordController,
                ),
                // Confirm PIN TextField
                EditableDialogButton(
                  label: 'Confirm  Password',
                  hint: '',
                  showEdit: true,
                  controller: confirmPasswordController,
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Consumer<UpdatePasswordProvider>(
                      builder: (context, updatePasswordProvider, child) {
                        final isLoading =
                            updatePasswordProvider.state ==
                            UpdatePasswordState.loading;

                        return ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    // Add save logic here
                                    final currentPassword =
                                        currentPasswordController.text.trim();
                                    final newPassword =
                                        newPasswordController.text.trim();
                                    final confirmPassword =
                                        confirmPasswordController.text.trim();

                                    if (currentPassword.isEmpty ||
                                        newPassword.isEmpty ||
                                        confirmPassword.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please fill all fields',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    // Verify current password from SharedPreferences
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final storedPassword =
                                        prefs.getString('password') ?? '';

                                    // Debug: Print stored password length for troubleshooting
                                    print(
                                      'Debug: Stored password length: ${storedPassword.length}',
                                    );
                                    print(
                                      'Debug: Current password length: ${currentPassword.length}',
                                    );
                                    print(
                                      'Debug: Stored password: ${storedPassword.isNotEmpty ? "***" : "EMPTY"}',
                                    );

                                    if (storedPassword.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'No stored password found. Please log out and log in again.',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    if (currentPassword != storedPassword) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Current password is incorrect',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    if (newPassword != confirmPassword) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'New passwords do not match',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    // Password validation matching PHP backend rules
                                    if (newPassword.length < 6 ||
                                        newPassword.length > 16) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Password must be 6–16 characters long',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                      return;
                                    }

                                    // Check for uppercase letter
                                    if (!RegExp(
                                      r'[A-Z]',
                                    ).hasMatch(newPassword)) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Password must include at least one uppercase letter',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                      return;
                                    }

                                    // Check for lowercase letter
                                    if (!RegExp(
                                      r'[a-z]',
                                    ).hasMatch(newPassword)) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Password must include at least one lowercase letter',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                      return;
                                    }

                                    // Check for special character (including underscore)
                                    if (!RegExp(
                                      r'[\W_]',
                                    ).hasMatch(newPassword)) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Password must include at least one special character',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                      return;
                                    }

                                    // Additional password strength validation
                                    if (!RegExp(
                                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                                    ).hasMatch(newPassword)) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Password must contain at least one uppercase letter, one lowercase letter, and one number',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                      return;
                                    }

                                    // Get user ID from SharedPreferences
                                    final userId =
                                        prefs.getString('user_id') ?? '';

                                    if (userId.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('User ID not found'),
                                        ),
                                      );
                                      return;
                                    }

                                    // Update password using UpdatePasswordProvider
                                    try {
                                      final updatePasswordProvider =
                                          Provider.of<UpdatePasswordProvider>(
                                            context,
                                            listen: false,
                                          );

                                      // Show loading state
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Row(
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                              SizedBox(width: 16),
                                              Text('Updating password...'),
                                            ],
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );

                                      // Call the update password API
                                      await updatePasswordProvider
                                          .updatePassword(
                                            UpdatePasswordRequest(
                                              userId: userId,
                                              newPassword: newPassword,
                                            ),
                                          );

                                      // Check the result
                                      if (updatePasswordProvider.state ==
                                          UpdatePasswordState.success) {
                                        // Success
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Password updated successfully: ${updatePasswordProvider.response?.message ?? ''}',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        // Update local storage
                                        await prefs.setString(
                                          'password',
                                          newPassword,
                                        );

                                        // Wait a moment for SharedPreferences to be fully committed
                                        await Future.delayed(const Duration(milliseconds: 100));
                                        
                                        // Close the password edit dialog
                                        Navigator.of(context).pop();
                                        
                                        // Close the profile dialog
                                        Navigator.of(context).pop();
                                      } else {
                                        // Error
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Password update failed: ${updatePasswordProvider.errorMessage ?? 'Unknown error'}',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error updating password: $e',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isLoading ? Colors.grey : Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    "UPDATE",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void showEditDialog1(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return ChangeNotifierProvider(
        create: (context) => UpdatePinProvider(),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 8,
          backgroundColor: Colors.white,
          child: _buildEdit1(context),
        ),
      );
    },
  );
}

Widget _buildEdit1(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      final currentPinController = TextEditingController();
      final newPinController = TextEditingController();
      final confirmPinController = TextEditingController();

      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 350,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),

                Text(
                  'Change PIN',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                EditableDialogButton(
                  label: 'Current PIN',
                  hint: '',
                  showEdit: true,
                  controller: currentPinController,
                ),
                // New PIN TextField
                EditableDialogButton(
                  label: 'New PIN',
                  hint: '',
                  showEdit: true,
                  controller: newPinController,
                ),
                // Confirm PIN TextField
                EditableDialogButton(
                  label: 'Confirm PIN',
                  hint: '',
                  showEdit: true,
                  controller: confirmPinController,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Consumer<UpdatePinProvider>(
                      builder: (context, updatePinProvider, child) {
                        final isLoading = updatePinProvider.isLoading;

                        return ElevatedButton(
                          onPressed: isLoading ? null : () async {
                            final currentPin = currentPinController.text.trim();
                            final newPin = newPinController.text.trim();
                            final confirmPin = confirmPinController.text.trim();

                            if (currentPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                ),
                              );
                              return;
                            }

                            // Verify current PIN from SharedPreferences
                            final prefs = await SharedPreferences.getInstance();
                            final storedPin = prefs.getString('pin') ?? '';

                            if (storedPin.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No stored PIN found. Please log out and log in again.'),
                                ),
                              );
                              return;
                            }

                            // if (currentPin != storedPin) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //       content: Text('Current PIN is incorrect'),
                            //     ),
                            //   );
                            //   return;
                            // }

                            if (newPin != confirmPin) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('New PINs do not match'),
                                ),
                              );
                              return;
                            }

                            // PIN validation
                            if (newPin.length < 4 || newPin.length > 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('PIN must be 4–6 digits long'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            // Check if PIN contains only digits
                            if (!RegExp(r'^\d+$').hasMatch(newPin)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('PIN must contain only digits'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            // Get user ID from SharedPreferences
                            final userId = prefs.getString('user_id') ?? '';

                            if (userId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('User ID not found'),
                                ),
                              );
                              return;
                            }

                            // Update PIN using UpdatePinProvider
                            try {
                              // Show loading state
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                      SizedBox(width: 16),
                                      Text('Updating PIN...'),
                                    ],
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              // Call the update PIN API
                              await updatePinProvider.updatePin(
                                userId: userId,
                                oldPin: currentPin,
                                newPin: newPin,
                              );

                              // Check the result
                              if (updatePinProvider.response?.success == true) {
                                // Success
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      updatePinProvider.response?.message ?? 'PIN updated successfully',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Update local storage
                                await prefs.setString('pin', newPin);

                                // Wait a moment for SharedPreferences to be fully committed
                                await Future.delayed(const Duration(milliseconds: 100));
                                
                                // Close the PIN edit dialog
                                Navigator.of(context).pop();
                                
                                // Close the profile dialog
                                Navigator.of(context).pop();
                              } else {
                                // Error - PIN update failed
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      updatePinProvider.errorMessage ?? 'PIN update failed',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error updating PIN: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLoading ? Colors.grey : Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  "UPDATE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
