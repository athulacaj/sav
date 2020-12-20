import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Autoverify extends StatefulWidget {
  final size;
  final child;
  Autoverify({this.size, this.child});
  @override
  _AutoverifyState createState() => _AutoverifyState();
}

class _AutoverifyState extends State<Autoverify> {
  @override
  void initState() {
    changeAutoVerify();
    super.initState();
  }

  bool _loaded = false;
  void changeAutoVerify() async {
    await Future.delayed(Duration(seconds: 5));
    _loaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        _loaded == false
            ? Container(
                width: widget.size.width,
                color: Colors.grey.withOpacity(0.4),
                height: widget.size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitWave(
                      color: Color(0xff36b58b),
                      size: 20.0,
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
