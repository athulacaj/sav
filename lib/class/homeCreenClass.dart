import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sav/screens/path/user/homeScreen/Carousel.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class HomeScreenClass {
  getCarouselData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snap = await _firestore
          .collection('home/670511/ads')
          .doc('670511')
          .get()
          .timeout(Duration(seconds: 15));
      List _homeAds = snap.data()!['homeAds'];
      List homeAds = _homeAds.reversed.toList();
      List imageSliders = getImageSliders(homeAds);
    } catch (e) {}
  }
}
