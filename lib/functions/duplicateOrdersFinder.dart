import 'package:cloud_firestore/cloud_firestore.dart';

class DuplicateOrderFinder {
  static String find(
    List<DocumentSnapshot<Map<String, dynamic>>> _allOrders,
  ) {
    List duplicateOrdersList = [];
    String toReturn = '';
    for (int i = 0; i < _allOrders.length; i++) {
      for (int j = i + 1; j < _allOrders.length - 1; j++) {
        if (_allOrders[i]['details'].length ==
            _allOrders[j]['details'].length) {
          List firstOrderList = _allOrders[i]['details'];
          List secondOrderList = _allOrders[j]['details'];
          bool isDuplicate = false;
          for (int a = 0; a < firstOrderList.length; a++) {
            if (firstOrderList[a]['name'] == secondOrderList[a]['name'] &&
                firstOrderList[a]['quantity'] ==
                    secondOrderList[a]['quantity']) {
              isDuplicate = true;
            } else {
              isDuplicate = false;
              break;
            }
          }
          if (isDuplicate) {
            // duplicateOrdersList.add([
            //   _allOrders[i]['userData']['name'],
            //   _allOrders[j]['userData']['name']
            // ]);
            toReturn = toReturn +
                _allOrders[i]['userData']['name'].split(" ")[0] +
                ": ${_allOrders.length - i} "
                    " and " +
                _allOrders[j]['userData']['name'].split(" ")[0] +
                ": ${_allOrders.length - j} " +
                "\n";
          }
        }
      }
    }
    for (var order in duplicateOrdersList) {
      print("duplicate : ${order}");
    }
    return toReturn;
  }
}
