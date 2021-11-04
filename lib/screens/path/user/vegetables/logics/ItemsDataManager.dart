import 'package:cloud_firestore/cloud_firestore.dart';

enum CategoryEnum { vegetables, driedFish, fruits, others }
CategoryEnum selectedEnum(String title) {
  switch (title) {
    case "Vegetables":
      return CategoryEnum.vegetables;
    case "Dried Fish":
      return CategoryEnum.driedFish;
    case "Fruits":
      return CategoryEnum.fruits;
    case "Other Items":
      return CategoryEnum.others;
  }
  return CategoryEnum.vegetables;
}

class ItemsDataManger {
  List? details;
  ItemsDataManger({required this.details});
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future categoryChange(String category) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _firestore.collection('items').doc('$category').get();
      details = snap.data()!['allInfo'];
      print("data changed $details");
    } catch (e) {}
  }
}
