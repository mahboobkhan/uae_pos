import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardUtils {
  static void copyToClipboard(String text, BuildContext context, {String? message}) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Copied to clipboard')),
    );
  }

  // Capitalize first letter helper
  static  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
