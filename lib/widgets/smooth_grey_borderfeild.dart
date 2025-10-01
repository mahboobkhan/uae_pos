import 'package:flutter/material.dart';

class SimpleGreyBorderContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color color;

  const SimpleGreyBorderContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    final double containerWidth = width ?? screenWidth * 0.13;
    final double containerHeight = height ?? screenHeight * 0.04;

    return Center(
      child: Container(
        height: containerHeight,
        width: containerWidth,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(0), // Adjust if you want rounded
        ),
        child: child,
      ),
    );
  }
}
