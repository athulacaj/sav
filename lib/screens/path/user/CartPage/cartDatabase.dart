import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class OrderManage {
  String uid;
  Map userData;
  DateTime sDate;
  OrderManage({this.userData, this.uid, this.sDate});
  Future<void> saveOrder(List orderData) async {
    DateTime time = sDate;
    int timeInMs = time.millisecondsSinceEpoch;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference firstRef = _firestore
        .collection('orders/byTime/${time.toString().substring(0, 10)}')
        .doc('$uid!$timeInMs');
    DocumentReference secondRef =
        _firestore.collection('orders/by/$uid').doc('$timeInMs');
    batch.set(firstRef, {
      'details': orderData,
      'userData': userData,
      'uid': uid,
      'docId': '$timeInMs',
      'time': DateTime.now(),
      'status': 'ordered',
    });
    batch.set(secondRef, {
      'details': orderData,
      'userData': userData,
      'uid': uid,
      'docId': '$uid!$timeInMs',
      'time': DateTime.now(),
      'status': 'ordered',
    });
    await batch.commit();
  }
}
