import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardUtils {
  static void copyToClipboard(String text, BuildContext context, {String? message}) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Copied to clipboard')),
    );
  }
}
