import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1.0; // Ajuste a largura do traço conforme necessário

    double startY = size.height / 2; // Posição vertical do traço
    double endX = size.width; // Tamanho horizontal do traço

    canvas.drawLine(Offset(0.0, startY), Offset(endX, startY), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
