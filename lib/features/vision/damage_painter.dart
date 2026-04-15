// lib/features/vision/damage_painter.dart
import 'package:flutter/material.dart';

class DamagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke; 

    double boxSize = size.width * 0.5;
    double left = (size.width - boxSize) / 2;
    double top = (size.height - boxSize) / 2;

    final rect = Rect.fromLTWH(left, top, boxSize, boxSize);

    canvas.drawRect(rect, paint);

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.redAccent,
    );

    const textSpan = TextSpan(
      text: " Searching for Road Damage... ", 
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    
    double textY = top - 25;
    if (textY < 0) textY = top + 5;

    textPainter.paint(canvas, Offset(left, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; 
  }
}