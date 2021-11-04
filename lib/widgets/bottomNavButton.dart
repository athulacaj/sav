import 'package:flutter/material.dart';

class BottomNavButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onClick;
  BottomNavButton(
      {required this.title, required this.icon, required this.onClick});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          onClick();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 1),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
              ),
              SizedBox(height: 2),
              Text(title),
            ],
          ),
        ));
  }
}
