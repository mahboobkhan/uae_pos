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
