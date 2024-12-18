import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sav/screens/path/admin/print/mutipleThermalPrint.dart';
import 'package:sav/screens/path/admin/print/thermalPrint.dart';

Future<List?> showTableBottomSheet(BuildContext context,
    List<DocumentSnapshot<Map<String, dynamic>>>? allOrders, String whichType) {
  Table table = Table(allOrders: allOrders);
  Map vegMap = table.buildTable();
  List vegList = vegMap['items'];
  vegList.sort();
  return showModalBottomSheet<List>(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      int selectedDeliveryBoy = -1;
      int selectedShop = -1;
      return StatefulBuilder(builder: (context, StateSetter setState) {
        Size size = MediaQuery.of(context).size;
        return Container(
          height: size.height - 100,
          // color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 9),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(whichType),
                ],
              ),
              Divider(),
              SizedBox(height: 2),
              Expanded(
                  child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                itemCount: vegList.length,
                itemBuilder: (BuildContext context, int index) {
                  String? itemName = vegList[index];
                  print(table.buildTable());
                  double qty = vegMap[itemName];
                  String unit = vegMap["${itemName}unit"];
                  return Material(
                      elevation: 2,
                      child: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                              '$itemName : ${qty.toStringAsFixed(2)} $unit')));
                },
              )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MultipleThermalPrint([], [])));
                  },
                  child: Text("   Print   ")),
              SizedBox(height: 4),
            ],
          ),
        );
      });
    },
  );
}

class Table {
  List<DocumentSnapshot<Map<String, dynamic>>>? allOrders = [];
  Table({this.allOrders});
  List vegetableList = [];
  Map vegMap = {};
  Map buildTable() {
    vegetableList = [];
    vegMap = {};
    for (DocumentSnapshot<Map<String, dynamic>> snap in allOrders!) {
      List orderItems = snap.data()!['details'];
      if (snap.data()!['status'] == "canceled") {
        continue;
      }

      for (Map item in orderItems) {
// if(vegetableList.contains(item['en'])){}else{
//
// }

        String vegName = item['name'];
        if (item['unit'] == 'no') vegName += " ";

        if (vegMap[vegName] != null) {
          double qty = item['quantity'];
          if (item['unit'] == 'g') {
            qty = (qty / 1000);
          }
          vegMap[vegName] += qty;
        } else {
          double qty = item['quantity'];
          // if (item['unit'] == 'g') {
          //   qty = (qty / 1000);
          // }
          vegetableList.add(vegName);
          vegMap[vegName] = qty;
          vegMap["${vegName}unit"] = item['unit'];
        }
      }
    }
    vegMap['items'] = vegetableList;
    return vegMap;
  }
}
