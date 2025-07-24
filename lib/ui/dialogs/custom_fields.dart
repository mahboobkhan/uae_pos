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
        style: const TextStyle(fontSize: 18, color: Colors.black),
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
                    child: Text(e, style: const TextStyle(fontSize: 12)),
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
  final double? width; // 👈 Optional width

  const CustomDropdownWithAddButton({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.onAddPressed,
    this.width, // 👈 Optional
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
            right: 4,
            top: 6,
            bottom: 6,
            child: GestureDetector(
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

  const InfoBox({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100], // light blue fill
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

