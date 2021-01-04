import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

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
//     ticket.cut();
//     int i = 0;
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

class MultipleThermalPrint extends StatefulWidget {
  final List<DocumentSnapshot> allData;
  final List<int> refNoList;
  MultipleThermalPrint(this.allData, this.refNoList);
  @override
  _MultipleThermalPrintState createState() => _MultipleThermalPrintState();
}

class _MultipleThermalPrintState extends State<MultipleThermalPrint> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  TestPrint testPrint;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    testPrint = TestPrint(allData: widget.allData, refNoList: widget.refNoList);
  }

  double totalQuantity(List details) {
    double totalQ = 0;
    for (Map data in details) {
      totalQ = totalQ + data['quantity'];
    }
    return totalQ;
  }

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff36b58b),
        title: Text('Print Multiple Order'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Device:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: DropdownButton(
                      items: _getDeviceItems(),
                      onChanged: (value) => setState(() => _device = value),
                      value: _device,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.brown,
                    onPressed: () {
                      initPlatformState();
                    },
                    child: Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: _connected ? Colors.red : Colors.green,
                    onPressed: _connected ? _disconnect : _connect,
                    child: Text(
                      _connected ? 'Disconnect' : 'Connect',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                child: RaisedButton(
                  color: Colors.brown,
                  onPressed: () {
                    testPrint.sample(pathImage);
                  },
                  child: Text('Print Order',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}

class TestPrint {
  final List allData;
  final List refNoList;
  TestPrint({@required this.allData, this.refNoList});
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  double totalQuantity(List details) {
    double totalQ = 0;
    for (Map data in details) {
      totalQ = totalQ + data['quantity'];
    }
    return totalQ;
  }

  sample(String pathImage) async {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        int i = 0;
        for (DocumentSnapshot snap in allData) {
          int refNo = refNoList[i];
          Map userData = snap.data()['userData'];
          List orderData = snap.data()['details'];

          Timestamp timestamp = snap.data()['time'];
          DateTime date = timestamp.toDate();
          var now = new DateTime.now();
          var formatter = new DateFormat('dd-MM-yyyy');
          String formattedDate = formatter.format(date);
          bluetooth.printCustom("Sales Order", 3, 1);
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printLeftRight("RefNo: $refNo", "Date : $formattedDate", 1);
          bluetooth.printCustom(
              "--------------------------------------------------------------",
              0,
              0);
          bluetooth.printCustom(
              "${spacedTextForHeading('SL', 20)}${spacedTextForHeading('ITEM', 50)}${spacedTextForHeading('QTY', 30)}",
              1,
              0);
          bluetooth.printCustom(
              "--------------------------------------------------------------",
              0,
              0);
          for (var i = 0; i < orderData.length; i++) {
            // bluetooth.printLeftRight(
            // "${spacedTextAlignSL('${(i + 1) * 70}', 20)}${spacedTextAlignName('    ${orderData[i]['en']}', 50)}",
            // "${spacedTextAlignRight(' ${orderData[i]['quantity']} kg', 30)}",
            // 0);
            bluetooth.printLeftRight(
                "${spacedTextAlignSL('${(i + 1)}', 20)}  ${orderData[i]['en']}",
                "${orderData[i]['quantity']} kg",
                1);
          }
          bluetooth.printCustom(
              "--------------------------------------------------------------",
              0,
              0);

          // print total
          bluetooth.printCustom(
              " Total : ${totalQuantity(orderData)} kg", 1, 1);
          bluetooth.printCustom(
              "--------------------------------------------------------------",
              0,
              0);

          bluetooth.printCustom(
              "Shop:  ${userData['shopName']}  / ${userData['name'].toString().toUpperCase()}  ",
              1,
              1);
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.paperCut();

          i++;
        }
      }
    });
  }
}

String spacedTextForHeading(String text, int percent) {
  int total = 50;
  int spaceForText = ((total * percent) / 100).floor();
  int spaceToAdd = ((spaceForText - text.length) / 2).floor();
  print(spaceToAdd);
  String space = makeSpaceForHeading(spaceToAdd);
  return '$space$text$space|';
}

String spacedTextAlignSL(String text, int percent) {
  if (text.length == 1) {
    return '  $text${makeSpace(6)}';
  } else if (text.length == 2) {
    return '  $text${makeSpace(5)}';
  } else {
    return '  $text${makeSpace(4)}';
  }
}

String spacedTextAlignName(String text, int percent) {
  int total = 64;
  int spaceForText = ((total * percent) / 100).floor();
  int spaceToAdd = ((spaceForText - text.length) / 2).floor();
  print(spaceToAdd);
  String space = makeSpace(spaceToAdd);
  return '$text$space$space';
}

String spacedTextAlignRight(String text, int percent) {
  int total = 64;
  int spaceForText = ((total * percent) / 100).floor();
  int spaceToAdd = ((spaceForText - text.length) / 2).floor();
  print(spaceToAdd);
  String space = makeSpace(spaceToAdd);
  return '$space$space$text';
}

String makeSpaceForHeading(int t) {
  String toReturn = '';
  for (int i = 0; i < t - 1; i++) {
    toReturn = toReturn + " ";
  }
  return toReturn;
}

String makeSpace(int t) {
  String toReturn = '';
  for (int i = 0; i < t; i++) {
    toReturn = toReturn + " ";
  }
  return toReturn;
}
