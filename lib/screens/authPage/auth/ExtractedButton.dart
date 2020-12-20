import 'package:flutter/material.dart';

class ExtractedButton extends StatelessWidget {
  ExtractedButton({this.text, this.colour, this.onclick, this.textColour});
  final String text;
  final Color colour;
  final Color textColour;
  final Function onclick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          onPressed: onclick,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
                color: textColour != null ? textColour : Colors.white),
          ),
        ),
      ),
    );
  }
}
