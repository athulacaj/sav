// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:sav/screens/path/admin/print/thermalPrintCopy.dart';
//
// convert() {
//   var str = "Hello world";
//   var bytes = utf8.encode(str);
//   var base64Str = base64.encode(bytes);
//   print(base64Str);
// }
//
// class WidgetToImage extends StatefulWidget {
//   @override
//   _WidgetToImageState createState() => new _WidgetToImageState();
// }
//
// class _WidgetToImageState extends State<WidgetToImage> {
//   GlobalKey _globalKey = new GlobalKey();
//
//   bool inside = false;
//   Uint8List imageInMemory;
//   ByteData byteData;
//   Future<Uint8List> _capturePng() async {
//     try {
//       print('inside');
//       inside = true;
//       RenderRepaintBoundary boundary =
//           _globalKey.currentContext.findRenderObject();
//       ui.Image image = await boundary.toImage(pixelRatio: 3);
//       print(image.width);
//       print(image.height);
//       byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       Uint8List pngBytes = byteData.buffer.asUint8List();
// //      String bs64 = base64Encode(pngBytes);
// //      print(pngBytes);
// //      print(bs64);
//       print('png done');
//
//       setState(() {
//         imageInMemory = pngBytes;
//         inside = false;
//       });
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => ThermalPrintCopy(byteData)));
//       return pngBytes;
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return RepaintBoundary(
//       key: _globalKey,
//       child: new Scaffold(
//           body: SafeArea(
//         child: SingleChildScrollView(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: new Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             child: new Text(
//                               'SL',
//                             ),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 border: Border(
//                                     right: BorderSide(color: Colors.black87))),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 3,
//                           child: Container(
//                             child: new Text(
//                               'Item',
//                             ),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 border: Border(
//                                     right: BorderSide(color: Colors.black87))),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             child: new Text(
//                               'QTY',
//                             ),
//                             alignment: Alignment.center,
//                           ),
//                         ),
//                       ],
//                     ),
//                     width: size.width,
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black87)),
//                   ),
//                   for (int i = 0; i < 105; i++)
//                     Container(
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               child: new Text(
//                                 '$i',
//                               ),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   border: Border(
//                                       right:
//                                           BorderSide(color: Colors.black87))),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: Container(
//                               child: new Text(
//                                 '$i kg',
//                               ),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   border: Border(
//                                       right:
//                                           BorderSide(color: Colors.black87))),
//                             ),
//                           ),
//                           Expanded(
//                             child: Container(
//                               child: new Text(
//                                 'QTY',
//                               ),
//                               alignment: Alignment.center,
//                             ),
//                           ),
//                         ],
//                       ),
//                       width: size.width,
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black87)),
//                     ),
//                   new RaisedButton(
//                     child: Text('capture Image '),
//                     onPressed: _capturePng,
//                   ),
//                   inside
//                       ? CircularProgressIndicator()
//                       : imageInMemory != null
//                           ? Container(
//                               child: Image.memory(imageInMemory),
//                               margin: EdgeInsets.all(10))
//                           : Container(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       )),
//     );
//   }
// }
