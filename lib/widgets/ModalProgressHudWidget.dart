import 'package:flutter/material.dart';
//
// class ModalProgressHUD extends StatelessWidget {
//   final Widget? child;
//   final bool? inAsyncCall;
//   ModalProgressHUD({this.child, this.inAsyncCall});
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Stack(
//       children: [
//         child!,
//         inAsyncCall!
//             ? Container(
//                 width: size.width,
//                 height: size.height,
//                 alignment: Alignment.center,
//                 color: Colors.grey.withOpacity(.4),
//                 child: CircularProgressIndicator(),
//               )
//             : Container(),
//       ],
//     );
//   }
// }
//

class ModalProgressHUD extends StatelessWidget {
  final Widget? child;
  final bool? inAsyncCall;
  ModalProgressHUD({this.child, this.inAsyncCall});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        child!,
        inAsyncCall!
            ? Container(
                width: size.width,
                height: size.height,
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(.4),
                child: CircularProgressIndicator(),
              )
            : Container(),
      ],
    );
  }
}
