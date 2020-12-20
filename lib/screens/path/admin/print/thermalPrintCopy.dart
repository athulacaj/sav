// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
// import 'dart:io' show Platform;
// import 'package:intl/intl.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:image/image.dart' as Img;
//
// import 'dart:convert' show utf8;
// import 'dart:io';
//
// class ThermalPrintCopy extends StatefulWidget {
//   final ByteData bytes;
//   ThermalPrintCopy(this.bytes);
//   @override
//   _ThermalPrintCopyState createState() => _ThermalPrintCopyState();
// }
//
// class _ThermalPrintCopyState extends State<ThermalPrintCopy> {
//   PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
//   List<PrinterBluetooth> _devices = [];
//   String _devicesMsg;
//   BluetoothManager bluetoothManager = BluetoothManager.instance;
//   bool _showSpinner = false;
//   Map userData;
//   @override
//   void initState() {
//     _showSpinner = false;
//     initFunction();
//     super.initState();
//   }
//
//   void initFunction() async {
//     print('!mounted $mounted');
//     if (Platform.isAndroid) {
//       bluetoothManager.state.listen((val) {
//         print('state = $val');
//         if (!mounted) return;
//         if (val == 12) {
//           print('on');
//           initPrinter(3);
//         } else if (val == 10) {
//           print('off');
//           setState(() => _devicesMsg = 'Bluetooth Disconnect!');
//         }
//       });
//     } else {
//       initPrinter(3);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: _showSpinner,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Print'),
//         ),
//         body: _devices.isEmpty
//             ? Center(child: Text(_devicesMsg ?? ''))
//             : Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: _devices.length,
//                       itemBuilder: (c, i) {
//                         return ListTile(
//                           leading: Icon(Icons.print),
//                           title: Text(_devices[i].name),
//                           subtitle: Text(_devices[i].address),
//                           onTap: () {
//                             _startPrint(_devices[i]);
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                       height: 500,
//                       child: SingleChildScrollView(child: returnImage())),
//                   FlatButton(
//                     onPressed: () async {
//                       initPrinter(10);
//                       _showSpinner = true;
//                       setState(() {});
//                       await Future.delayed(Duration(seconds: 10));
//                       _showSpinner = false;
//                       setState(() {});
//                     },
//                     child: Text('Scan'),
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//       ),
//     );
//   }
//
//   void initPrinter(int timeOut) {
//     _printerManager.startScan(Duration(seconds: timeOut));
//     print('scanning Finished');
//     _printerManager.scanResults.listen((val) {
//       if (!mounted) return;
//       setState(() => _devices = val);
//       if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
//     });
//   }
//
//   Future<void> _startPrint(PrinterBluetooth printer) async {
//     _printerManager.selectPrinter(printer);
//     final result =
//         await _printerManager.printTicket(await _ticket(PaperSize.mm80));
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         content: Text(result.msg),
//       ),
//     );
//   }
//
//   Widget returnImage() {
//     final Uint8List newBytes = widget.bytes.buffer.asUint8List();
//     final Img.Image image = Img.decodeImage(newBytes);
//     var thumbnail = Img.copyResize(image, width: 600, height: 900);
//     var t = Img.copyCrop(thumbnail, 0, 30, 1000, 2000);
//     final Uint8List kk = Img.encodePng(t);
//     return Image.memory(kk);
//   }
//
//   Future<Ticket> _ticket(PaperSize paper) async {
//     final ticket = Ticket(paper);
//     final ByteData data = await rootBundle.load('assets/ask.png');
//     final Uint8List bytes = data.buffer.asUint8List();
//     final Uint8List newBytes = widget.bytes.buffer.asUint8List();
//     final Img.Image image = Img.decodeImage(newBytes);
//     // var thumbnail = Img.copyResize(image, width: 303, height: 100);
//     // var t = Img.copyCrop(image, 20, 100, 1000, 60);
//     var thumbnail = Img.copyResize(image, width: 500, height: 1000);
//     var t = Img.copyCrop(thumbnail, 0, 40, 500, 50);
//     ticket.image(t);
//     ticket.cut();
//
//     return ticket;
//   }
//
//   @override
//   void dispose() {
//     _printerManager.stopScan();
//     super.dispose();
//   }
// }
//
// int totalQuantity(List details) {
//   int totalQ = 0;
//   for (Map data in details) {
//     totalQ = totalQ + data['quantity'];
//   }
//   return totalQ;
// }
