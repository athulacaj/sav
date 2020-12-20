import 'package:flutter/material.dart';

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final Path path = Path();
//    path.lineTo(0, size.height);
//    path.lineTo(size.width, 0.0);
    path.lineTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
