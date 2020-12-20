import 'package:flutter/material.dart';

class ExtractedButton extends StatelessWidget {
  ExtractedButton({this.text, this.colour, this.onclick});
  final String text;
  final Color colour;
  final Function onclick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 1.0,
        color: colour,
        borderRadius: BorderRadius.circular(8.0),
        child: MaterialButton(
          onPressed: onclick,
          minWidth: 180.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
