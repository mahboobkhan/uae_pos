import 'package:flutter/material.dart';

void showProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        backgroundColor: Colors.transparent,
        child: _buildDialogContent(context),
      );
    },
  );
}

Widget _buildDialogContent(BuildContext context) {
  return Stack(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Name: John Doe',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(thickness: 1),
            const _InfoRow(label: 'Email', value: 'john@example.com'),
            const _InfoRow(label: 'Phone', value: '+123456789'),
            _DialogButton(
              label: 'Change Password',
              onTap: () {},
              showEdit: true,
            ),
            _DialogButton(label: 'New PIN', onTap: () {}, showEdit: true),
            _DialogButton(
              label: 'Finance History',
              onTap: () {},
              showArrow: true,
            ),
          ],
        ),
      ),
      const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        child: Icon(Icons.perm_identity_sharp, color: Colors.black, size: 40),
      ),
    ],
  );
}

class _DialogButton extends StatefulWidget {
  final String label;
  final bool showArrow;
  final bool showEdit;
  final VoidCallback? onTap;

  const _DialogButton({
    required this.label,
    this.showArrow = false,
    this.showEdit = false,
    this.onTap,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
  bool _obscure = true;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return widget.showEdit
        ? Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: widget.label,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.orange,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.green,
                          size: 18,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showEditDialog(context);
                        },
                      ),
                    ],
                  ),
                  isDense: true,
                ),
              ),
            ),
          ],
        )
        : ListTile(
          contentPadding: EdgeInsets.only(right: 12),
          title: Text(widget.label),
          trailing:
              widget.showArrow
                  ? const Icon(Icons.arrow_forward_ios, size: 16)
                  : null,
          onTap: widget.onTap,
        );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        backgroundColor: Colors.grey,
        child: _buildEdit(context),
      );
    },
  );
}

Widget _buildEdit(BuildContext context) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      Container(
        width: 300,
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create New PIN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // New PIN TextField
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("New PIN", style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 6),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 20),

            // Confirm PIN TextField
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Confirm PIN", style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 6),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 30),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

void showShortServicesPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String customer = '';
      String? selectedService;
      String charges = '';

      final List<String> serviceOptions = [
        'Cleaning',
        'Consulting',
        'Repairing',
      ];

      return AlertDialog(
        backgroundColor: const Color(0xFFE0E0E0),
        // light gray
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.red),
        ),
        titlePadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(20),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Add Services",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "SID-01100011",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTextField(
                    label: 'SERVICE NAME',
                    onChanged: (val) => customer = val,
                  ),
                  _buildServiceDropdown(
                    selectedService,
                    serviceOptions,
                    onChanged: (val) => selectedService = val,
                  ),
                  _buildTextField(
                    label: 'COST',
                    keyboardType: TextInputType.number,
                    onChanged: (val) => charges = val,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:  Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildTextField({
  required String label,
  required Function(String) onChanged,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: SizedBox(
      width: 110, // Matched with dropdown
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // Always on top
          labelStyle: const TextStyle(fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
          ),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    ),
  );
}

Widget _buildServiceDropdown(
  String? selectedValue,
  List<String> options, {
  required void Function(String?) onChanged,
}) {
  return SizedBox(
    width: 160,
    child: DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'SERVICE NAME',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // Always on top
        labelStyle: const TextStyle(fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.add_circle, color: Colors.red),
          onPressed: () {
            // Add custom service action
          },
        ),
      ),
      hint: Text(
        'Select',
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      onChanged: onChanged,
      items:
          options.map((String value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
    ),
  );
}

// Services Project
void showServicesProjectPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String customer = '';
      String? selectedService;
      String charges = '';

      final List<String> serviceOptions = [
        'Cleaning',
        'Consulting',
        'Repairing',
      ];

      return AlertDialog(
        backgroundColor: const Color(0xFFE0E0E0),
        // light gray
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.red),
        ),
        titlePadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(20),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Short Services",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "SID-01100011",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProjectTextField(
                    label: 'CUSTOMER',
                    onChanged: (val) => customer = val,
                  ),
                  _buildProjectDropdown(
                    selectedService,
                    serviceOptions,
                    onChanged: (val) => selectedService = val,
                  ),
                  _buildProjectTextField(
                    label: 'CHARGES',
                    keyboardType: TextInputType.number,
                    onChanged: (val) => charges = val,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildProjectTextField({
  required String label,
  required Function(String) onChanged,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: SizedBox(
      width: 110, // Matched with dropdown
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // Always on top
          labelStyle: const TextStyle(fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
          ),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    ),
  );
}

Widget _buildProjectDropdown(
  String? selectedValue,
  List<String> options, {
  required void Function(String?) onChanged,
}) {
  return SizedBox(
    width: 160,
    child: DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'SERVICE INSTITUTE',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // Always on top
        labelStyle: const TextStyle(fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.add_circle, color: Colors.red),
          onPressed: () {
            // Add custom service action
          },
        ),
      ),
      hint: Text(
        'Select',
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      onChanged: onChanged,
      items:
          options.map((String value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
    ),
  );
}
