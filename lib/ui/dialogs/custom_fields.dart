import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final double width;
  final bool enabled;
  final bool isPassword;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.width = 220,
    this.enabled = true,
    this.isPassword = false,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          suffixIcon:
              widget.suffixIcon ??
              (widget.isPassword
                  ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                  : null),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final double width;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.width = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
        onChanged: onChanged,
        items:
            options
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: const TextStyle(fontSize: 16)),
                  ),
                )
                .toList(),
      ),
    );
  }
}
class CustomDropdownWithAddButton extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final VoidCallback onAddPressed;
  final double? width;

  const CustomDropdownWithAddButton({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.onAddPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.white,
              labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              contentPadding: const EdgeInsets.fromLTRB(12, 14, 48, 14),
            ),
            items: items
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 16)),
            ))
                .toList(),
            onChanged: onChanged,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          Positioned(
            right: 12,
            top: 6,
            bottom: 6,
            child: GestureDetector(
              onTap: onAddPressed,
              child: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: const Icon(Icons.add, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField1 extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final double? width;

  const CustomTextField1({
    super.key,
    required this.label,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Agar null ho to parent width use karega
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        onChanged: onChanged,
      ),
    );
  }
}
class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color; // single required color


  const InfoBox({
    super.key,
    required this.label,
    required this.value,
    required this.color,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          color: color, // light blue fill
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey), // grey border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class InstituteManagementDialog extends StatefulWidget {
  const InstituteManagementDialog({super.key});

  @override
  State<InstituteManagementDialog> createState() => _InstituteManagementDialogState();
}

class _InstituteManagementDialogState extends State<InstituteManagementDialog> {
  final List<String> institutes = [];
  final TextEditingController addController = TextEditingController();
  final TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(12),
      insetPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: 363,
        height: 305,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Institutes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 25, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Add input field and button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: addController,
                      cursorColor: Colors.blue,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: "Add institute...",
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      if (addController.text.trim().isNotEmpty) {
                        setState(() {
                          institutes.add(addController.text.trim());
                          addController.clear();
                        });
                      }
                    },
                    child: const Text("Add", style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // List
            Expanded(
              child: institutes.isEmpty
                  ? const Center(child: Text('No institutes', style: TextStyle(fontSize: 14)))
                  : ListView.builder(
                itemCount: institutes.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(institutes[index], style: const TextStyle(fontSize: 14)),
                      trailing: SizedBox(
                        width: 80,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18, color: Colors.green),
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                final updated = await showDialog<String>(
                                  context: context,
                                  builder: (_) => EditInstituteDialog(
                                    initialValue: institutes[index],
                                  ),
                                );

                                if (updated != null && updated.trim().isNotEmpty) {
                                  setState(() {
                                    institutes[index] = updated.trim();
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  institutes.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditInstituteDialog extends StatefulWidget {
  final String initialValue;

  const EditInstituteDialog({super.key, required this.initialValue});

  @override
  State<EditInstituteDialog> createState() => _EditInstituteDialogState();
}

class _EditInstituteDialogState extends State<EditInstituteDialog> {
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              cursorColor: Colors.blue,
              controller: _editController,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: Colors.grey),
                ),
                labelText: 'Edit institute',
                labelStyle: TextStyle(color: Colors.blue),
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_editController.text.trim().isNotEmpty) {
                      Navigator.pop(context, _editController.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoBoxNoColor extends StatelessWidget {
  final String label;
  final String value;

  const InfoBoxNoColor({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          // No background color
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey), // grey border remains
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
