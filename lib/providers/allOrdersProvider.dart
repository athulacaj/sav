import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllOrdersProvider extends ChangeNotifier {
  static List<DocumentSnapshot<Map<String, dynamic>>> _allOrdersFiltered = [];
  static List adminsList = [];
  static Future<void> getOnce() async {
    if (_allOrdersFiltered.isEmpty) {
      DateTime _whichDay = DateTime.now();
      print("called once");
      QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection('orders/byTime/${_whichDay.toString().substring(0, 10)}')
          .orderBy("time", descending: true)
          .get();
      _allOrdersFiltered = doc.docs;
    }
  }

  void filterOrder(
      String whichType,
      List<DocumentSnapshot<Map<String, dynamic>>> allOrders,
      bool callRefresh) {
    print(whichType);
    if (whichType == 'all') {
      _allOrdersFiltered = allOrders;
    } else if (whichType == 'others') {
      _allOrdersFiltered = [];
      for (DocumentSnapshot<Map<String, dynamic>> order in allOrders) {
        bool isOrderedFromAdmin = false;
        for (DocumentSnapshot adminData in adminsList) {
          if (order['uid'] == adminData['uid']) {
            isOrderedFromAdmin = true;
            break;
          }
        }
        if (!isOrderedFromAdmin) {
          _allOrdersFiltered.add(order);
          print(order.data());
        }
      }
    } else {
      _allOrdersFiltered = allOrders
          .where((value) => value.data()!['uid'] == whichType)
          .toList();
    }
    if (callRefresh) notifyListeners();
  }

  List<DocumentSnapshot<Map<String, dynamic>>> getFilteredOrdersList() {
    return _allOrdersFiltered;
  }

  static void setFilteredOrdersList(
      List<DocumentSnapshot<Map<String, dynamic>>> list) {
    _allOrdersFiltered = list;
  }
}
