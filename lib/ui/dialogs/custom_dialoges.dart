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
            _DialogButton(label: 'New PIN', onTap: () {
            }, showEdit: true),
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
        child: Icon(Icons.perm_identity_sharp, color: Colors.black,size: 40,),
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
    super.key,
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
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
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
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
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
