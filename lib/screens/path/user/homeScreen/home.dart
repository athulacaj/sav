import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'package:sav/screens/path/user/vegetables/byItems.dart';
import 'Carousel.dart';
import 'drawer/drawer.dart';
import 'extractedBox.dart';
import 'package:sav/screens/path/admin/adminHomeScreen.dart';
import 'package:sav/screens/path/user/MyOrders/MyOrders.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'cartBadge.dart';
import 'package:flutter/services.dart';
import 'package:sav/firebaseMessaging.dart';

Widget carousel;
bool _showSpinner = false;
List<Widget> imageSliders = [];
TabController _tabController;

class HomeScreen extends StatefulWidget {
  static String id = 'Home_Screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _showSpinner = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    getFcmToken();
    _tabController = TabController(length: 2, vsync: this);

    _scrollController.addListener(() {
      print(_scrollController.offset);
    });
    getAds();
  }

  getFcmToken() async {
    FireBaseMessagingClass fireBaseMessagingClass =
        FireBaseMessagingClass(context);
    fireBaseMessagingClass.firebaseConfigure();
    String fcmId = await fireBaseMessagingClass.getFirebaseToken();
    Provider.of<IsInList>(context, listen: false).setFcmId(fcmId);
    fireBaseMessagingClass.fcmSubscribe();
  }

  void getAds() async {
    DocumentSnapshot snap =
        await _firestore.collection('home').doc('ads').get();
    List temp = snap.data()['ads'];
    List ads = temp.reversed.toList();
    imageSliders = getImageSliders(ads);
    setState(() {});
  }

  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Map _userDetails =
        Provider.of<IsInList>(context, listen: false).userDetails;
    if (_showSpinner == false) {
      carousel = makeCarouousel(imageSliders, size);
    }

    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        drawer: MyDrawer(),
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xff36b58b),
          // backgroundColor: Colors.teal,
          title: Text('SAV Online '),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: [
            CartBadge(),
            // IconButton(
            //     icon: Icon(Icons.notifications, color: Colors.white),
            //     onPressed: () {})
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              carousel,
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Text(
                        '${_userDetails['shopName']}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      color: Colors.tealAccent.withOpacity(0.1),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(
                                  color: _tabController.index == 0
                                      ? Color(0xff3FD4A2)
                                      : Colors.grey.shade200,
                                  minWidth: size.width / 2 - 14,
                                  height: 40,
                                  onPressed: () {
                                    selectedIndex = 0;
                                    _tabController.index = 0;
                                    setState(() {});
                                  },
                                  child: Text(
                                    'Order Now',
                                    style: TextStyle(
                                        color: _tabController.index == 0
                                            ? Colors.white
                                            : Colors.black),
                                  )),
                              FlatButton(
                                  color: _tabController.index == 1
                                      ? Color(0xff3FD4A2)
                                      : Colors.grey.shade200,
                                  minWidth: size.width / 2 - 14,
                                  height: 40,
                                  onPressed: () {
                                    selectedIndex = 1;
                                    _tabController.index = 1;
                                    setState(() {});
                                  },
                                  child: Text(
                                    'Manage Orders',
                                    style: TextStyle(
                                        color: _tabController.index == 1
                                            ? Colors.white
                                            : Colors.black),
                                  )),
                            ],
                          ),
                          SizedBox(height: 15),
                          IndexedStack(
                            children: <Widget>[
                              Visibility(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: ExtractedBox(
                                              image: 'assets/vegetables.jpg',
                                              title: 'Vegetables'),
                                          onTap: () async {
                                            _showSpinner = true;
                                            setState(() {});

                                            try {
                                              DocumentSnapshot snap =
                                                  await _firestore
                                                      .collection('items')
                                                      .doc('vegetables')
                                                      .get();
                                              List vegetablesFromDb =
                                                  snap.data()['allInfo'];
                                              print(vegetablesFromDb);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ByItems(
                                                            title: 'Vegetables',
                                                            details:
                                                                vegetablesFromDb,
                                                            isClosed: false,
                                                          )));
                                            } catch (e) {
                                              print('error form Db $e');
                                            }

                                            _showSpinner = false;
                                            setState(() {});
                                          },
                                        ),
                                        GestureDetector(
                                          child: ExtractedBox(
                                              image: 'assets/unakameen.jpg',
                                              title: 'Dried Fish'),
                                          onTap: () async {
                                            _showSpinner = true;
                                            setState(() {});

                                            try {
                                              DocumentSnapshot snap =
                                                  await _firestore
                                                      .collection('items')
                                                      .doc('driedFish')
                                                      .get();
                                              List diredFishFromDb =
                                                  snap.data()['allInfo'];
                                              print(diredFishFromDb);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ByItems(
                                                            title: 'Dried Fish',
                                                            details:
                                                                diredFishFromDb,
                                                            isClosed: false,
                                                          )));
                                            } catch (e) {
                                              print('error form Db $e');
                                            }

                                            _showSpinner = false;
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    _userDetails['isAdmin'] != null
                                        ? _userDetails['isAdmin']
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    child: ExtractedBox(
                                                        image:
                                                            'assets/admin.png',
                                                        title: 'Admin Pannel'),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AdminHomeScreen()));
                                                    },
                                                  ),
                                                  // GestureDetector(
                                                  //   child: ExtractedBox(
                                                  //       // image: 'assets/vegetables.jpg',
                                                  //       title: 'Save'),
                                                  //   onTap: () async {
                                                  //     _showSpinner = true;
                                                  //     DateTime now = DateTime.now();
                                                  //     setState(() {});
                                                  //     DocumentSnapshot snap =
                                                  //         await _firestore
                                                  //             .collection('items')
                                                  //             .doc('vegetables')
                                                  //             .get();
                                                  //     await _firestore
                                                  //         .collection('backUp')
                                                  //         .doc(
                                                  //             '${now.millisecondsSinceEpoch} veg')
                                                  //         .set(snap.data());
                                                  //     _showSpinner = false;
                                                  //     setState(() {});
                                                  //   },
                                                  // ),
                                                ],
                                              )
                                            : Container()
                                        : Container(),
                                  ],
                                ),
                                maintainState: true,
                                visible: _tabController.index == 0,
                              ),
                              Visibility(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: ExtractedBox(
                                              image: 'assets/orders.png',
                                              title: 'Orders'),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyOrders(
                                                          fromWhere: 'notnull',
                                                        )));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                maintainState: true,
                                visible: _tabController.index == 1,
                              ),
                            ],
                            index: _tabController.index,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
