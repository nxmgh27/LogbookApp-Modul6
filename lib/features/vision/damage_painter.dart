// lib/features/vision/damage_painter.dart
import 'package:flutter/material.dart';

class DamagePainter extends CustomPainter {
  final double aiX;
  final double aiY;

  DamagePainter({required this.aiX, required this.aiY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke; 

    double boxSize = size.width * 0.4; 
    
    double centerX = aiX * size.width;
    double centerY = aiY * size.height;

    double left = centerX - (boxSize / 2);
    double top = centerY - (boxSize / 2);

    final rect = Rect.fromLTWH(left, top, boxSize, boxSize);
    canvas.drawRect(rect, paint);

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.redAccent,
    );

    const textSpan = TextSpan(
      text: " [D40] POTHOLE - 92% ", 
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    
    double textY = top - 25;
    if (textY < 0) textY = top + boxSize + 5; 

    textPainter.paint(canvas, Offset(left, textY));
  }

  @override
  bool shouldRepaint(covariant DamagePainter oldDelegate) {
    return oldDelegate.aiX != aiX || oldDelegate.aiY != aiY; 
  }
}