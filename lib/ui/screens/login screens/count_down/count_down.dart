import 'dart:async';
import 'package:flutter/material.dart';

class CountdownText extends StatefulWidget {
  final VoidCallback onCountdownFinished;
  const CountdownText({required this.onCountdownFinished,super.key});

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  int _seconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 1) {
        setState(() {
          _seconds--;
        });
      } else {
        timer.cancel(); // Stop when it reaches 1
        widget.onCountdownFinished(); // 👈 Callback when done
        setState(() {
          _seconds = 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "$_seconds - Seconds",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 16,
      ),
    );
  }
}
