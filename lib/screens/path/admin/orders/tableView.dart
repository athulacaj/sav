import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List> showTableBottomSheet(
    BuildContext context, List<DocumentSnapshot> allOrders) {
  Table table = Table(allOrders: allOrders);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Expanded(
                  child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                itemCount: table.buildTable()['items'].length,
                itemBuilder: (BuildContext context, int index) {
                  String item = table.buildTable()['items'][index];
                  return Material(
                      elevation: 2,
                      child: Container(
                          padding: EdgeInsets.all(8),
                          child:
                              Text('$item : ${table.buildTable()[item]} kg')));
                },
              )),
              SizedBox(height: 15),
            ],
          ),
        );
      });
    },
  );
}

class Table {
  List<DocumentSnapshot> allOrders = [];
  Table({this.allOrders});
  List vegetableList = [];
  Map vegMap = {};
  Map buildTable() {
    vegetableList = [];
    vegMap = {};
    for (DocumentSnapshot snap in allOrders) {
      List orderItems = snap.data()['details'];
      for (Map item in orderItems) {
// if(vegetableList.contains(item['en'])){}else{
//
// }
        if (vegMap[item['name']] != null) {
          vegMap[item['name']] = vegMap[item['name']] + item['quantity'];
        } else {
          vegetableList.add(item['name']);
          vegMap[item['name']] = item['quantity'];
        }
      }
    }
    vegMap['items'] = vegetableList;
    return vegMap;
  }
}
