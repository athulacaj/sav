import 'package:flutter/material.dart';

class ShaderMaskLoading extends StatefulWidget {
  @override
  _ShaderMaskLoadingState createState() => _ShaderMaskLoadingState();
}

class _ShaderMaskLoadingState extends State<ShaderMaskLoading>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> animation1;
  Animation<Color> animation2;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    animation1 = ColorTween(
            begin: Colors.grey.withOpacity(0.5), end: Colors.grey.shade100)
        .animate(_controller);
    animation2 = ColorTween(
            begin: Colors.grey.shade100, end: Colors.grey.withOpacity(0.5))
        .animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (_controller.status == AnimationStatus.dismissed) {
        _controller.forward();
      }
      this.setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(colors: [animation1.value, animation2.value])
            .createShader(bounds);
      },
      child: Container(
        height: 290.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(13),
                    topLeft: Radius.circular(13)),
              ),
            ),
            SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                height: 13,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                height: 13,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                height: 25,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
