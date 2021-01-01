import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Print extends StatefulWidget {
  @override
  _PrintState createState() => new _PrintState();
}

class _PrintState extends State<Print> {
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
    initSavetoPath();
    testPrint = TestPrint();
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'yourlogo.png';
    var bytes = await rootBundle.load("assets/images/yourlogo.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Blue Thermal Printer'),
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
                    child: Text('PRINT TEST',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
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
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  sample(String pathImage) async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

//     var response = await http.get("IMAGE_URL");
//     Uint8List bytes = response.bodyBytes;
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printCustom("Sales Order", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("  Shop Name : Acaj veg shop", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Ref no :123", "Date :12-07-2020", 1);
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
        bluetooth.printCustom(
            "${spacedTextAlignLeft('  1', 20)}${spacedTextAlignLeft('  Cauliflower', 40)}${spacedTextAlignRight('30 kg', 40)}",
            0,
            0);
        bluetooth.printCustom(
            "${spacedTextAlignLeft('  2', 20)}${spacedTextAlignLeft('  Cabbage', 40)}${spacedTextAlignRight('50 kg', 40)}",
            0,
            0);
        bluetooth.printCustom(
            "--------------------------------------------------------------",
            0,
            0);

        // print total
        bluetooth.printCustom("Total : 100 kg", 1, 1);

        bluetooth.printNewLine();
        bluetooth.paperCut();
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

String spacedTextAlignLeft(String text, int percent) {
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
