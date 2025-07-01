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
                      style: TextStyle(fontSize: 12, color: Colors.black54),
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
        items:
            items.map((item) {
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
        child: GestureDetector(
          onTap: () {

          },
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
                      style: TextStyle(fontSize: 12, color: Colors.black54),
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
        items:
            items.map((item) {
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
        elevation: 8,
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
    Colors.green.shade100,
    Colors.yellow.shade100,
    Colors.orange.shade100,
    Colors.pink.shade100,
    Colors.purple.shade100,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.blue.shade100,
    Colors.lightGreen.shade200,
    Colors.pink.shade200,
    Colors.grey.shade300,
    Colors.lightBlue,
    Colors.cyan,
    Colors.lime,
    Colors.pink,
    Colors.blueGrey,
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
                        decoration: const InputDecoration(
                          labelText: "Tag Name",
                          border: OutlineInputBorder(),
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

void showCompanyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(10),
        child: CompanyProfileDialog(),
      );
    },
  );
}

class CompanyProfileDialog extends StatefulWidget {
  const CompanyProfileDialog({super.key});

  @override
  State<CompanyProfileDialog> createState() => _CompanyProfileDialogState();
}

class _CompanyProfileDialogState extends State<CompanyProfileDialog> {
  DateTime issueDate = DateTime.now();
  DateTime expiryDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> employees = [{}];
  final double _fieldWidth = 280; // Uniform width for all fields
  final double _fieldHeight = 70; // Uniform height for single-line fields

  // Company information controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _tradeLicenseController = TextEditingController();
  final TextEditingController _companyTypeController = TextEditingController();
  final TextEditingController _legalFormController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _companyCodeController = TextEditingController();
  final TextEditingController _establishmentController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _contact2Controller = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _eChannelLoginController =
      TextEditingController();
  final TextEditingController _eChannelPassController = TextEditingController();

  @override
  void dispose() {
    // Dispose all controllers
    _companyNameController.dispose();
    _tradeLicenseController.dispose();
    _companyTypeController.dispose();
    _legalFormController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _companyCodeController.dispose();
    _establishmentController.dispose();
    _notesController.dispose();
    _contact2Controller.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _eChannelLoginController.dispose();
    _eChannelPassController.dispose();
    super.dispose();
  }

  Future<void> pickDate(BuildContext context, bool isIssueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isIssueDate ? issueDate : expiryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && mounted) {
      setState(() {
        if (isIssueDate) {
          issueDate = picked;
        } else {
          expiryDate = picked;
        }
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  void addEmployee() {
    setState(() {
      employees.add({
        'type': null,
        'position': TextEditingController(),
        'name': TextEditingController(),
        'emiratesId': TextEditingController(),
        'workPermit': TextEditingController(),
        'email': TextEditingController(),
        'contact': TextEditingController(),
      });
    });
  }

  void removeEmployee(int index) {
    if (employees.length > 1) {
      // Dispose controllers before removing
      employees[index]['position'].dispose();
      employees[index]['name'].dispose();
      employees[index]['emiratesId'].dispose();
      employees[index]['workPermit'].dispose();
      employees[index]['email'].dispose();
      employees[index]['contact'].dispose();

      setState(() {
        employees.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade200,
      insetPadding: const EdgeInsets.all(22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Company Profile",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Text("ORN 000000000200", style: TextStyle(fontSize: 12)),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Status bar
                _buildStatusBar(),
                const SizedBox(height: 20),

                // Company Fields
                _buildCompanyInformationSection(),
                const SizedBox(height: 20),

                // File upload
                _buildDocumentUploadSection(),
                const SizedBox(height: 20),

                // Employee Section
                _buildEmployeeSection(),
                const SizedBox(height: 20),

                // Payments section
                _buildPaymentsSection(),
                const SizedBox(height: 16),

                // Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green),
            ),
            child: const Text(
              "Regular/Walking",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            formatDate(DateTime.now()),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInformationSection() {
    return _buildSection(
      title: "Company Information",
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildTextField(
            "Company Name",
            controller: _companyNameController,
            isRequired: true,
          ),
          _buildTextField(
            "Trade License Number",
            controller: _tradeLicenseController,
            isRequired: true,
          ),
          _buildDropdownField("Company Type", [
            "LLC",
            "Sole Proprietor",
            "Branch",
          ], controller: _companyTypeController),
          _buildDropdownField("Legal Form", [
            "Form A",
            "Form B",
          ], controller: _legalFormController),
          _buildTextField(
            "Email I'd",
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          _buildTextField(
            "Contact Number",
            controller: _contactController,
            keyboardType: TextInputType.phone,
          ),
          _buildTextField("Company Code", controller: _companyCodeController),
          _buildTextField(
            "Establishment Number",
            controller: _establishmentController,
          ),
          _buildTextField("Note/Extra", controller: _notesController),
          _buildTextField(
            "Contact Number 2",
            controller: _contact2Controller,
            keyboardType: TextInputType.phone,
          ),
          _buildTextField("Physical Address", controller: _addressController),
          _buildTextField(
            "Website (E-Channel)",
            controller: _websiteController,
            keyboardType: TextInputType.url,
          ),
          _buildTextField(
            "E-Channel Login",
            controller: _eChannelLoginController,
          ),
          _buildTextField(
            "E-Channel Password",
            controller: _eChannelPassController,
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeSection() {
    return _buildSection(
      title: "Partner/Employee Records",
      child: Column(
        children: [
          ...employees.asMap().entries.map((entry) {
            final index = entry.key;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (employees.length > 1)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeEmployee(index),
                      ),
                    ),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildDropdownField(
                        "Employee Type",
                        ["Employee", "Partner"],
                        value: employees[index]['type'],
                        onChanged: (value) {
                          setState(() {
                            employees[index]['type'] = value;
                          });
                        },
                      ),
                      _buildTextField(
                        "Position",
                        controller: employees[index]['position'],
                      ),
                      _buildTextField(
                        "Name",
                        controller: employees[index]['name'],
                      ),
                      _buildTextField(
                        "Emirates ID",
                        controller: employees[index]['emiratesId'],
                      ),
                      _buildTextField(
                        "Work Permit No",
                        controller: employees[index]['workPermit'],
                      ),
                      _buildTextField(
                        "Email",
                        controller: employees[index]['email'],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildTextField(
                        "Contact No",
                        controller: employees[index]['contact'],
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildDocumentUploadSection(),
                ],
              ),
            );
          }).toList(),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: addEmployee,
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add Employee"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsSection() {
    return _buildSection(
      title: "Payments",
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPaymentTile("Pending Payments", "9700", Colors.red),
              _buildPaymentTile("Advance Payment", "10,000", Colors.green),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Use Advance funds Logic With Creating Tid",
            style: TextStyle(color: Colors.blue, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save form
                _saveFormData();
                Navigator.of(context).pop();
              }
            },
            text: 'Submit',
            backgroundColor: Colors.blue,
          ),
          const SizedBox(width: 20),
          Card(
            elevation: 8,

            child: OutlinedButton(
              onPressed: () {
                // Enable editing mode
                setState(() {});
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                side: const BorderSide(color: Colors.blue),
              ),
              child: const Text(
                "Editing",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveFormData() {
    // Save all form data here
    final companyData = {
      'name': _companyNameController.text,
      'license': _tradeLicenseController.text,
      'type': _companyTypeController.text,
      // Add all other fields...
    };

    // Process employee data
    final employeeData =
        employees
            .map(
              (emp) => {
                'type': emp['type'],
                'name': emp['name']?.text ?? '',
                // Add other employee fields...
              },
            )
            .toList();

    // You can now use companyData and employeeData as needed
    debugPrint('Company Data: $companyData');
    debugPrint('Employee Data: $employeeData');
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextField(
    String label, {
    bool isRequired = false,
    int maxLines = 1,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
  }) {
    return SizedBox(
      width: _fieldWidth,
      height: maxLines == 1 ? _fieldHeight : null,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? '*' : ''}',
          border: const OutlineInputBorder(),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        validator:
            isRequired
                ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                }
                : null,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items, {
    String? value,
    TextEditingController? controller,
    ValueChanged<String?>? onChanged,
  }) {
    String? dropdownValue =
        items.contains(value ?? controller?.text)
            ? (value ?? controller?.text)
            : null;

    return SizedBox(
      width: _fieldWidth,
      height: _fieldHeight,
      child: DropdownButtonFormField<String>(
        value: dropdownValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: (val) {
          if (controller != null) {
            controller.text = val ?? '';
          }
          if (onChanged != null) {
            onChanged(val);
          }
        },
      ),
    );
  }

  Widget _buildDocumentUploadSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Upload Documents",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: _fieldWidth,
                child: _buildTextField("Doc Name", isRequired: false),
              ),
              _buildDateField("Issue Date", true),
              _buildDateField("Expiry Date", false),
              const Icon(Icons.check_circle, color: Colors.green, size: 22),
              SizedBox(
                child: CustomButton(
                  text: 'Upload File',
                  onPressed: () {},
                  backgroundColor: Colors.green,
                  icon: Icons.file_copy_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, bool isIssue) {
    return SizedBox(
      height: _fieldHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => pickDate(context, isIssue),
            child: Container(
              width: _fieldWidth * 0.6,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Text(
                isIssue ? formatDate(issueDate) : formatDate(expiryDate),
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(String title, String amount, Color color) {
    return SizedBox(
      width: _fieldWidth * 0.45,
      height: _fieldHeight,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "AED $amount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showIndividualProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(10),
        child: IndividualProfileDialog(),
      );
    },
  );
}

class IndividualProfileDialog extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade900),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Individual Profile",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "ORN. 00001-0000001",
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStatusBar(),
                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    children: [
                      _buildTextField("Client Name"),
                      _buildTextField("Emiratis I'd"),
                      _buildTextField("Email I'd"),
                      _buildTextField("Contact Number"),
                      _buildTextField("Contact Number - 2"),
                      _buildTextField("Note/Extra"),
                      _buildTextField("Physical Address"),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Add More",
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _buildPaymentRow(),

                  const SizedBox(height: 20),
                  _buildDocumentUploadRow(),

                  const SizedBox(height: 20),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return SizedBox(
      width: 250,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            "Regular/Walking (Dropdown)",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const Text("12-02-2025", style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPaymentRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildPaymentTile("Pending Payments", "9700", Colors.red),
        _buildPaymentTile("Advance Payment", "10,000", Colors.green),
      ],
    );
  }

  Widget _buildPaymentTile(String title, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadRow() {
    return Wrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildTextField("Doc Name"),
        const Icon(Icons.calendar_month, color: Colors.red, size: 20),
        const Text("12-02-2025 - 02:59 pm"),
        const Icon(Icons.calendar_month, color: Colors.red, size: 20),
        const Text("12-02-2025 - 02:59 pm"),
        const Icon(Icons.check_circle, color: Colors.green, size: 24),
        CustomButton(
          text: 'Upload File',
          onPressed: () {},
          backgroundColor: Colors.green,
          icon: Icons.file_copy_outlined,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          text: 'Editing',
          onPressed: () {},
          backgroundColor: Colors.blue,
        ),
        SizedBox(width: 20),
        CustomButton(
          text: 'Submit',
          onPressed: () {},
          backgroundColor: Colors.red,
        ),
      ],
    );
  }
}
