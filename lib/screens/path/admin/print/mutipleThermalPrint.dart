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
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert' show utf8;
// import 'dart:io';
//
// class MutipleThermalPrint extends StatefulWidget {
//   final List<DocumentSnapshot> allData;
//   final List<int> refNoList;
//   MutipleThermalPrint(this.allData, this.refNoList);
//   @override
//   _MutipleThermalPrintState createState() => _MutipleThermalPrintState();
// }
//
// class _MutipleThermalPrintState extends State<MutipleThermalPrint> {
//   PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
//   List<PrinterBluetooth> _devices = [];
//   String _devicesMsg;
//   BluetoothManager bluetoothManager = BluetoothManager.instance;
//   bool _showSpinner = false;
//   @override
//   void initState() {
//     _showSpinner = true;
//     showSpinner();
//     initFunction();
//     super.initState();
//   }
//
//   void showSpinner() async {
//     await Future.delayed(Duration(seconds: 3));
//     setState(() {});
//     _showSpinner = false;
//     setState(() {});
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
//     Size size = MediaQuery.of(context).size;
//     return ModalProgressHUD(
//       inAsyncCall: _showSpinner,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color(0xff36b58b),
//           title: Text('Print'),
//         ),
//         body: Column(
//           children: [
//             Spacer(),
//             _devices.isEmpty
//                 ? Center(child: Text(_devicesMsg ?? ''))
//                 : Column(
//                     children: [
//                       Container(
//                         height: size.height - 120,
//                         child: ListView.builder(
//                           itemCount: _devices.length,
//                           itemBuilder: (c, i) {
//                             return ListTile(
//                               leading: Icon(Icons.print),
//                               title: Text(_devices[i].name),
//                               subtitle: Text(_devices[i].address),
//                               onTap: () {
//                                 _startPrint(_devices[i]);
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//             Spacer(),
//             FlatButton(
//               onPressed: () async {
//                 initPrinter(10);
//                 _showSpinner = true;
//                 setState(() {});
//                 await Future.delayed(Duration(seconds: 10));
//                 _showSpinner = false;
//                 setState(() {});
//               },
//               child: Text('Scan'),
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
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
//
//     final result =
//         await _printerManager.printTicket(await _ticket(PaperSize.mm80));
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         content: Text(result.msg),
//       ),
//     );
//   }
//
//   Future<Ticket> _ticket(PaperSize paper) async {
//     final ticket = Ticket(paper);
//     int i = 0;
//     ticket.cut();
//     for (DocumentSnapshot snap in widget.allData) {
//       int refNo = widget.refNoList[i];
//       Map userData = snap.data()['userData'];
//       List orderData = snap.data()['details'];
//
//       Timestamp timestamp = snap.data()['time'];
//       DateTime date = timestamp.toDate();
//       var now = new DateTime.now();
//       var formatter = new DateFormat('dd-MM-yyyy');
//       String formattedDate = formatter.format(date);
//       ticket.text(
//         'Sales Order',
//         styles: PosStyles(
//             align: PosAlign.center,
//             height: PosTextSize.size1,
//             width: PosTextSize.size2),
//         linesAfter: 1,
//       );
//       ticket.text(
//         'shop:  ${userData['shopName']}  / ${userData['name'].toString().toUpperCase()}    ',
//         styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//             height: PosTextSize.size1,
//             width: PosTextSize.size1),
//         linesAfter: 0,
//       );
//
//       ticket.emptyLines(1);
//       ticket.row([
//         PosColumn(
//             text: 'RefNo: $refNo',
//             width: 3,
//             styles: PosStyles(
//               fontType: PosFontType.fontA,
//               bold: false,
//               align: PosAlign.left,
//             )),
//         PosColumn(
//             text: 'Date : $formattedDate',
//             width: 9,
//             styles: PosStyles(
//               fontType: PosFontType.fontA,
//               bold: false,
//               align: PosAlign.right,
//             )),
//       ]);
//       ticket.row([
//         PosColumn(
//             text: '------------------------------------------------',
//             width: 12),
//       ]);
//       ticket.row([
//         PosColumn(
//             text: 'SL',
//             width: 1,
//             styles: PosStyles(
//               fontType: PosFontType.fontB,
//               bold: true,
//               width: PosTextSize.size2,
//             )),
//         PosColumn(
//           text: '|',
//           width: 1,
//           styles: PosStyles(
//             fontType: PosFontType.fontB,
//             height: PosTextSize.size2,
//             // turn90: true,
//           ),
//         ),
//         PosColumn(
//             text: 'ITEM',
//             width: 6,
//             styles: PosStyles(
//               fontType: PosFontType.fontA,
//               bold: true,
//               width: PosTextSize.size1,
//             )),
//         PosColumn(
//           text: '|',
//           width: 1,
//           styles: PosStyles(
//             fontType: PosFontType.fontA,
//             height: PosTextSize.size1,
//             // turn90: true,
//           ),
//         ),
//         PosColumn(
//             text: 'QTY',
//             width: 2,
//             styles: PosStyles(
//               fontType: PosFontType.fontA,
//               bold: true,
//               width: PosTextSize.size1,
//             )),
//         PosColumn(
//           text: '|',
//           width: 1,
//           styles: PosStyles(
//             fontType: PosFontType.fontB,
//             height: PosTextSize.size2,
//             // turn90: true,
//           ),
//         ),
//       ]);
//       ticket.hr();
//
//       for (var i = 0; i < orderData.length; i++) {
//         ticket.row([
//           PosColumn(
//               text: '${i + 1}',
//               width: 1,
//               styles: PosStyles(fontType: PosFontType.fontA)),
//           PosColumn(
//               text: '|',
//               width: 1,
//               styles: PosStyles(
//                   fontType: PosFontType.fontB,
//                   height: PosTextSize.size2,
//                   // turn90: true,
//                   codeTable: PosCodeTable.wpc1252_1)),
//           PosColumn(
//               text: ' ${orderData[i]['en']}',
//               width: 6,
//               styles: PosStyles(fontType: PosFontType.fontA)),
//           PosColumn(
//               text: '|',
//               width: 1,
//               styles: PosStyles(
//                 fontType: PosFontType.fontB,
//                 height: PosTextSize.size2,
//                 codeTable: PosCodeTable.greek,
//                 // turn90: true,
//               )),
//           PosColumn(
//               width: 2,
//               text: '${orderData[i]['quantity']} kg',
//               styles: PosStyles(
//                   fontType: PosFontType.fontA, align: PosAlign.right)),
//           PosColumn(
//               text: '|',
//               width: 1,
//               styles: PosStyles(
//                 fontType: PosFontType.fontB,
//                 height: PosTextSize.size2,
//                 // turn90: true,
//               )),
//         ]);
//       }
//       ticket.hr();
//       ticket.row([
//         PosColumn(
//             text: '', width: 9, styles: PosStyles(fontType: PosFontType.fontA)),
//         PosColumn(
//             text: '${totalQuantity(orderData)} kg',
//             width: 2,
//             styles: PosStyles(
//                 fontType: PosFontType.fontA,
//                 height: PosTextSize.size1,
//                 // turn90: true,
//                 align: PosAlign.right)),
//         PosColumn(
//             text: '', width: 1, styles: PosStyles(fontType: PosFontType.fontA)),
//       ]);
//       ticket.row([
//         PosColumn(
//             text: '------------------------------------------------',
//             width: 12),
//       ]);
//       ticket.feed(3);
//       i++;
//     }
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
