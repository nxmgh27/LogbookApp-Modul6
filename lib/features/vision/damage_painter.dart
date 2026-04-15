// lib/features/vision/damage_painter.dart
import 'package:flutter/material.dart';

class DamagePainter extends CustomPainter {
  final double aiX;
  final double aiY;
  // --- TAMBAHAN HOMEWORK: Parameter Dinamis ---
  final String label; 
  final int confidence; 

  DamagePainter({
    required this.aiX,
    required this.aiY,
    required this.label,
    required this.confidence,
  });

  // --- TAMBAHAN HOMEWORK: Logika Warna Dinamis ---
  Color _getDamageColor() {
    if (label.contains('D40')) return Colors.redAccent;      // Pothole = Merah (Bahaya)
    if (label.contains('D20')) return Colors.purpleAccent;   // Alligator Crack = Ungu
    if (label.contains('D10')) return Colors.orangeAccent;   // Transverse Crack = Oranye
    if (label.contains('D00')) return Colors.yellowAccent;   // Longitudinal Crack = Kuning (Ringan)
    
    return Colors.greenAccent;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Color damageColor = _getDamageColor();

    final paint = Paint()
      ..color = damageColor // Gunakan warna dinamis
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke; 

    double boxSize = size.width * 0.4; 
    double centerX = aiX * size.width;
    double centerY = aiY * size.height;

    double left = centerX - (boxSize / 2);
    double top = centerY - (boxSize / 2);

    final rect = Rect.fromLTWH(left, top, boxSize, boxSize);
    canvas.drawRect(rect, paint);

    // --- TAMBAHAN HOMEWORK: Styling Teks dengan Shadow ---
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      backgroundColor: damageColor.withValues(alpha: 0.8), 
      shadows: const [
        Shadow(
          color: Colors.black, // Bayangan hitam agar teks menonjol
          offset: Offset(1, 1),
          blurRadius: 3,
        ),
      ],
    );

    final textSpan = TextSpan(
      text: " [$label] - $confidence% ", 
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
    // Repaint jika koordinat ATAU labelnya berubah
    return oldDelegate.aiX != aiX || 
           oldDelegate.aiY != aiY || 
           oldDelegate.label != label; 
  }
}