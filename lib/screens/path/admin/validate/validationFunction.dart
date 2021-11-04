import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidationClass {
  static Future<List> getSavedData() async {
    List ordersList = [];
    final localData = await SharedPreferences.getInstance();
    String ordersListDataString = localData.getString('savedData') ?? '';
    print('saved data: $ordersListDataString');
    if (ordersListDataString == "null" || ordersListDataString == '') {
    } else {
      ordersList = jsonDecode(ordersListDataString);
    }
    return ordersList;
  }

  static saveData(Map data) async {
    List ordersList = await getSavedData();
    if (ordersList.length > 40) {
      ordersList.removeAt(0);
    }
    ordersList.add(data);
    final localData = await SharedPreferences.getInstance();
    String ordersListDataString = jsonEncode(ordersList);
    localData.setString('savedData', ordersListDataString);
  }

  static Future<List> getDataFromDatabase(String uid) async {
    // TODO: change duration
    String clName =
        DateTime.now().add(Duration(days: 1)).toString().substring(0, 10);
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("orders/byTime/$clName")
        .where('uid', isEqualTo: uid)
        .get();

    return data.docs;
  }

  bool validate(List offlineData, List onlineData) {
    // first validation checking the length is same
    if (offlineData.length == onlineData.length) {}
    return false;
  }
}
