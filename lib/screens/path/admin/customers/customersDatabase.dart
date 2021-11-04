import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sav/functions/showToastFunction.dart';

class CustomersDatabase {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<bool> addCustomer(Map<String, dynamic> data) async {
    if (data['name'] == '') {
      showToast("Give a name");
    } else if (data['phone'] == '') {
      showToast("Give a  number");
    } else if (data['phone'].length < 10 || data['phone'].length > 10) {
      showToast("Phone number must be 10 digit");
    } else {
      await _firestore.collection("customers").add(data);
      return true;
    }
    return false;
  }

  static deleteCustomer(String id) async {
    await _firestore.collection("customers").doc(id).delete();
  }

  static updateAreaList(List areaList) {
    _firestore
        .collection("customers")
        .doc("0")
        .set({"areaList": areaList, "name": "0"});
  }
}
