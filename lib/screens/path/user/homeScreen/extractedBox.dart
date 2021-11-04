import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ExtractedBox extends StatelessWidget {
  final String? image;
  final String? title;
  ExtractedBox({this.image, this.title});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      elevation: 4,
      child: Container(
        height: size.width / 3,
        width: size.width / 2 - 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
                image: AssetImage('$image'), fit: BoxFit.cover)),
        child: Stack(
          children: [
            // Image.asset('assets/vegetables.jpg'),
            Positioned(
              bottom: 0,
              child: Center(
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width / 2 - 18,
                    height: 30,
                    child: Center(
                      child: AutoSizeText(
                        '$title',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black12, Colors.black87])),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
