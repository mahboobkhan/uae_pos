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
      String serviceName = '';
      String? selectedInstitute;
      String cost = '';

      final List<String> instituteOptions = [
        'Institute A',
        'Institute B',
        'Institute C',
      ];

      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: SizedBox(
          width: 340,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      "ADD SERVICES",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Tid 000000000234",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(
                      label: 'SERVICE NAME',
                      onChanged: (val) => serviceName = val,
                    ),
                    const SizedBox(height: 12),

                    _buildDropdownWithPlus(
                      label: 'SELECT INSTITUTE',
                      value: selectedInstitute,
                      items: instituteOptions,
                      onChanged: (val) => selectedInstitute = val,
                      onAddPressed: () {
                        // Action for adding a new institute
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildTextField(
                      label: 'COST ',
                      keyboardType: TextInputType.number,
                      onChanged: (val) => cost = val,
                    ),

                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Create',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Cross icon top right
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.red),
                    onPressed: () => Navigator.of(context).pop(),
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
Widget _buildDropdownWithPlus({
  required String label,
  required String? value,
  required List<String> items,
  required Function(String?) onChanged,
  required VoidCallback onAddPressed,
}) {
  return Stack(
    children: [
      DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.fromLTRB(12, 14, 48, 14),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 13)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
      Positioned(
        right: 4,
        top: 6,
        bottom: 6,
        child: InkWell(
          onTap: onAddPressed,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: const Icon(Icons.add, size: 20, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}


Widget _buildTextField({
  required String label,
  required Function(String) onChanged,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      filled: true,
      fillColor: Colors.grey.shade200,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
    keyboardType: keyboardType,
    onChanged: onChanged,
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: SizedBox(
          width: 340,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      "SHORT SERVICES",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "SID-01100011",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildTextField1(
                      label: 'CUSTOMER',
                      onChanged: (val) => customer = val,
                    ),
                    const SizedBox(height: 12),

                    _buildDropdownWithPlus1(
                      label: 'SERVICE INSTITUTE',
                      value: selectedService,
                      items: serviceOptions,
                      onChanged: (val) => selectedService = val,
                      onAddPressed: () {
                        // Add custom service action
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildTextField1(
                      label: 'CHARGES',
                      keyboardType: TextInputType.number,
                      onChanged: (val) => charges = val,
                    ),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
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
                  ],
                ),
              ),

              // Close Icon
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.red),
                    onPressed: () => Navigator.of(context).pop(),
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
Widget _buildDropdownWithPlus1({
  required String label,
  required String? value,
  required List<String> items,
  required Function(String?) onChanged,
  required VoidCallback onAddPressed,
}) {
  return Stack(
    children: [
      DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.fromLTRB(12, 14, 48, 14),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 13)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
      Positioned(
        right: 4,
        top: 6,
        bottom: 6,
        child: InkWell(
          onTap: onAddPressed,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: const Icon(Icons.add, size: 20, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}
Widget _buildTextField1({
  required String label,
  required Function(String) onChanged,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      filled: true,
      fillColor: Colors.grey.shade200,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
    keyboardType: keyboardType,
    onChanged: onChanged,
  );
}


