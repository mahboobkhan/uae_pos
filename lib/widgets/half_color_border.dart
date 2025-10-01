import 'package:flutter/material.dart';

class SmoothGradientBorderContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color color;

  const SmoothGradientBorderContainer({
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
      child: CustomPaint(
        painter: SmoothGradientBorderPainter(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0), // Clip inner content
          child: Container(
            height: containerHeight,
            width: containerWidth,
            color: color, // ✅ White inside
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}

class SmoothGradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double borderWidth = 2.0;

    final RRect outerRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(0),
    );

    final Paint borderPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Colors.purpleAccent, Colors.green],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;

    canvas.drawRRect(outerRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
