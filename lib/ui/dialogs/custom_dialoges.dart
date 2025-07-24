import 'package:flutter/material.dart';

import 'custom_fields.dart';

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
              showEdit: false,
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
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.perm_identity_sharp, color: Colors.white, size: 40),
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
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.red,
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
                          color: Colors.red,
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
        backgroundColor: Colors.white,
        child: _buildEdit(context),
      );
    },
  );
}

Widget _buildEdit(BuildContext context) {
  bool obscureNewPIN = true;
  bool obscureConfirmPIN = true;

  return StatefulBuilder(
    builder: (context, setState) {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 300,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Create New PIN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 24),

                // New PIN TextField
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("New PIN", style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 6),
                TextField(
                  obscureText: obscureNewPIN,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNewPIN ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureNewPIN = !obscureNewPIN;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm PIN TextField
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Confirm PIN", style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 6),
                TextField(
                  obscureText: obscureConfirmPIN,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPIN
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPIN = !obscureConfirmPIN;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add save logic here
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "SAVE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actionsAlignment: MainAxisAlignment.start,

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
                    const Text(
                      "ADD SERVICES",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "Tid 000000000234",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    CustomTextField1(
                      label: 'SERVICE NAME',
                      onChanged: (val) => serviceName = val,
                    ),
                    const SizedBox(height: 12),

                    CustomDropdownWithAddButton(
                      label: 'SELECT INSTITUTE',
                      value: selectedInstitute,
                      items: instituteOptions,
                      onChanged: (val) => selectedInstitute = val,
                      onAddPressed: () {
                        showInstituteManagementDialog(context);
                      },
                    ),

                    const SizedBox(height: 12),

                    CustomTextField1(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
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
                child: IconButton(
                  icon: const Icon(Icons.close, size: 25, color: Colors.red),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    },
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    const Text(
                      "SHORT SERVICES",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "SID-01100011",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField1(
                      label: 'CUSTOMER',
                      onChanged: (val) => customer = val,
                    ),
                    const SizedBox(height: 12),

                    CustomDropdownWithAddButton(
                      label: 'SERVICE INSTITUTE',
                      value: selectedService,
                      items: serviceOptions,
                      onChanged: (val) => selectedService = val,
                      onAddPressed: () {
                        showInstituteManagementDialog(context);
                      },
                    ),
                    const SizedBox(height: 12),

                    CustomTextField1(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
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
                child: IconButton(
                  icon: const Icon(Icons.close, size: 25, color: Colors.red),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showInstituteManagementDialog(BuildContext context) {
  final List<String> institutes = [];
  final TextEditingController addController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  int? editingIndex;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ), // Slightly smaller radius
            ),
            contentPadding: const EdgeInsets.all(12), // Reduced padding
            insetPadding: const EdgeInsets.all(20), // Space around dialog
            content: SizedBox(
              width: 363,
              height: 305,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Compact header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Institutes',
                        style: TextStyle(
                          fontSize: 16, // Smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 25,color: Colors.red,),
                        // Smaller icon
                        padding: EdgeInsets.zero,
                        // Remove default padding
                        constraints: const BoxConstraints(),
                        // Remove minimum size
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Compact input field
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // align top
                    children: [
                      // TextField
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
                              border: InputBorder.none, // remove double border
                              isDense: true,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Add Button
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
                          child: const Text("Add", style: TextStyle(fontSize: 14,color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Compact list
                  Expanded(
                    child:
                        institutes.isEmpty
                            ? const Center(
                              child: Text(
                                'No institutes',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                            : ListView.builder(
                              shrinkWrap: true,
                              itemCount: institutes.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    // Makes tiles more compact
                                    visualDensity: VisualDensity.compact,
                                    // Even more compact
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    title: Text(
                                      institutes[index],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    trailing: SizedBox(
                                      width:
                                          80, // Constrained width for buttons
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 18,
                                              color: Colors.green,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed:
                                                () => _showEditDialog(
                                                  context,
                                                  setState,
                                                  institutes,
                                                  index,
                                                  editController,
                                                ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Colors.red,
                                            ),
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
        },
      );
    },
  );
}

void _showEditDialog(
  BuildContext context,
  StateSetter setState,
  List<String> institutes,
  int index,
  TextEditingController editController,
) {
  editController.text = institutes[index];
  showDialog(
    context: context,
    builder: (editContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: 250, // Smaller width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                cursorColor: Colors.blue,
                controller: editController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.grey),
                  ),
                  labelText: 'Edit institute',
                  labelStyle: TextStyle(
                    color: Colors.blue, ),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(editContext),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      if (editController.text.trim().isNotEmpty) {
                        setState(() {
                          institutes[index] = editController.text.trim();
                        });
                        Navigator.pop(editContext);
                      }
                    },
                    text: 'Save',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}



// short sevices 2nd dialog

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double borderRadius;
  final double? fontSize;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 6,
    this.fontSize,
    this.icon, // 👈 Accept icon
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child:
          icon == null
              ? Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: fontSize ?? 16),
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: fontSize ?? 16),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize ?? 16,
                    ),
                  ),
                ],
              ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String? selectedValue;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Icon? icon;

  const CustomDropdown({
    Key? key,
    required this.selectedValue,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey _key = GlobalKey();

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: GestureDetector(
        onTap: () async {
          final RenderBox renderBox =
              _key.currentContext!.findRenderObject() as RenderBox;
          final Offset offset = renderBox.localToGlobal(Offset.zero);
          final double width = renderBox.size.width;

          final selected = await showMenu<String>(
            context: context,
            position: RelativeRect.fromLTRB(
              offset.dx,
              offset.dy + renderBox.size.height,
              offset.dx + width,
              offset.dy,
            ),
            items:
                items.map((item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
          );

          if (selected != null) {
            onChanged(selected);
          }
        },
        child: Container(
          key: _key,
          width: 110,
          height: 25,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  selectedValue ?? hintText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: selectedValue == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              icon ?? const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> showAddTagDialog(BuildContext context) async {
  final TextEditingController _tagController = TextEditingController();
  Color? selectedColor;
  final List<Color> colors = [
    // Green
    Colors.green.shade600,
    Colors.green.shade800,

    Color(0xFFFF0000),

    // Blue
    Colors.blue.shade600,
    Colors.blue.shade800,
    Colors.lightBlue.shade700,

    // Red
    Colors.red.shade600,
    Colors.red.shade800,

    // Purple
    Colors.purple.shade600,
    Colors.purple.shade800,

    // Shocking pink (vibrant pinks)
    Colors.pink.shade600,
    Colors.pinkAccent.shade400,
    Colors.pinkAccent.shade700,

    // Teal
    Colors.teal.shade600,
    Colors.teal.shade800,

    // Orange
    Colors.orange.shade600,
    Colors.orange.shade800,

    // Yellow (darkest available)
    Colors.yellow.shade800,

    // Cyan
    Colors.cyan.shade700,
    Colors.cyan.shade900,

    // Lime (boldest shade)
    Colors.lime.shade800,

  ];

  return await showDialog<Map<String, dynamic>>(
    context: context,
    builder:
        (_) => StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                titlePadding: EdgeInsets.zero,
                title: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "New Tag",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                content: SizedBox(
                  width: 220,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _tagController,
                        decoration:  InputDecoration(
                          labelText: "Tag Name",
                          labelStyle: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.blue, width: 1), // 👈 your focused color here
                          ),
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children:
                            colors.map((color) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedColor = color);
                                },
                                child: Container(
                                  width: 41,
                                  height: 41,
                                  decoration: BoxDecoration(
                                    color: color,
                                    border: Border.all(
                                      color:
                                          selectedColor == color
                                              ? Colors.black
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'SAVE',
                        backgroundColor: Colors.blue,
                        borderRadius: 2,
                        onPressed: () {
                          if (_tagController.text.trim().isNotEmpty) {
                            Navigator.of(context).pop({
                              'tag': _tagController.text.trim(),
                              'color': selectedColor ?? colors[0],
                              // Default to first color if none selected
                            });
                          }
                        },
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ),
        ),
  );
}
