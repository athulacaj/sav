import 'package:flutter/material.dart';

void navigatorSlideAnimationFunction(BuildContext context, Widget screen) {
  Navigator.of(context).push(
      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
    return screen;
  }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
    var begin = Offset(1.0, 0.0);
    var end = Offset(0.0, 0.0);
    var tween = Tween(begin: begin, end: end);
    var offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }));
}
