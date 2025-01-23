import 'package:flutter/material.dart';

class ColorfulCircle extends StatefulWidget {
  @override
  _ColorfulCircleState createState() => _ColorfulCircleState();
}

class _ColorfulCircleState extends State<ColorfulCircle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RainbowCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Create a radial gradient for immersive blending
    final gradient = RadialGradient(
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
      ],
      stops: [
        0.1,
        0.25,
        0.4,
        0.55,
        0.7,
        0.85,
        1.0
      ], // Gradual transition points
    );

    // Create a rect for the gradient
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Create a paint object with the gradient
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..maskFilter = MaskFilter.blur(
          BlurStyle.normal, 10); // Add blur for immersive effect

    // Draw the circle with the gradient
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
