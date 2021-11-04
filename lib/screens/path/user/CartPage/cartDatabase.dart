import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sav/screens/path/admin/validate/validationFunction.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class OrderManage {
  String? uid;
  Map? userData;
  DateTime? deliveryDate;
  OrderManage({this.userData, this.uid, this.deliveryDate});
  Future<void> saveOrder(
      {required List orderData,
      required Function successFunction,
      required failedFunction}) async {
    List tempData = List.from(orderData);
    DateTime time = deliveryDate!;
    int timeInMs = time.millisecondsSinceEpoch;
    print(time.toString().substring(0, 10));
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference firstRef = _firestore
        .collection('orders/byTime/${time.toString().substring(0, 10)}')
        .doc('$uid!$timeInMs');
    DocumentReference secondRef =
        _firestore.collection('orders/by/$uid').doc('$timeInMs');
    batch.set(firstRef, {
      'details': tempData,
      'userData': userData,
      'uid': uid,
      'docId': '$timeInMs',
      'time': DateTime.now(),
      'status': 'ordered',
      'deliveryDate': deliveryDate,
    });
    batch.set(secondRef, {
      'details': tempData,
      'userData': userData,
      'uid': uid,
      'docId': '$uid!$timeInMs',
      'time': DateTime.now(),
      'status': 'ordered',
      'deliveryDate': deliveryDate,
    });
    Map data = {
      'details': tempData,
      'userData': userData,
      'uid': uid,
      'docId': '$uid!$timeInMs',
      'time': DateTime.now().toString(),
      'status': 'ordered',
      'deliveryDate': deliveryDate.toString(),
    };
    await successFunction();

    try {
      await batch.commit();
      await ValidationClass.saveData(data);
    } catch (e) {
      print("error saving order in database $e");
      failedFunction();
    }
  }
}
