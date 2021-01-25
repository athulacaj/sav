import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'cartDatabase.dart';
import 'orderSucessFulPage.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sav/sendFcm.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DeliverySlot extends StatefulWidget {
  @override
  _DeliverySlotState createState() => _DeliverySlotState();
}

class _DeliverySlotState extends State<DeliverySlot> {
  int selected = -1;
  DateTime _whichDay;
  DateTime selectedDate;
  bool _showSpinner = false;
  @override
  void initState() {
    _showSpinner = false;
    selected = -1;
    DateTime now = DateTime.now();
    _whichDay = new DateTime(now.year, now.month, now.day + 2);
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _whichDay,
        firstDate: DateTime(now.year, now.month, now.day + 2),
        lastDate: DateTime(now.year, now.month + 1, now.day - 1));
    if (picked != null && picked != _whichDay) _whichDay = picked;
    print('date changed');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var isInList = Provider.of<IsInList>(context, listen: false);
    var _allDetailsList = isInList.allDetails ?? [];
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff36b58b),
          title: Text('Select Delivery Date'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('app').doc('1.0').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {}
              return snapshot.data['update'] == false
                  ? Column(
                      children: [
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {
                            selectedDate = DateTime.now();
                            selected = 1;
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(
                                color: selected == 1
                                    ? Color(0xff36b58b).withOpacity(0.5)
                                    : Colors.white,
                                elevation: 4,
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: size.width,
                                    child: Text('Today'))),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            selected = 2;
                            DateTime now = DateTime.now();
                            selectedDate =
                                new DateTime(now.year, now.month, now.day + 1);

                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(
                                color: selected == 2
                                    ? Color(0xff36b58b).withOpacity(0.5)
                                    : Colors.white,
                                elevation: 4,
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: size.width,
                                    child: Text('Tomorrow'))),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            selected = 3;
                            await _selectDate(context);
                            selectedDate = _whichDay;
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(
                                color: selected == 3
                                    ? Color(0xff36b58b).withOpacity(0.5)
                                    : Colors.white,
                                elevation: 4,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: size.width,
                                  child: Text("Select Date (" +
                                      "${_whichDay.toLocal()}".split(' ')[0] +
                                      ")"),
                                )),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            print('order button clicked');
                            if (selectedDate != null) {
                              _showSpinner = true;
                              setState(() {});
                              print(selectedDate);
                              // List userData =
                              //     Provider.of<IsInList>(context, listen: false)
                              //         .userDetails;
                              OrderManage oderManage = OrderManage(
                                  uid: isInList.userDetails['uid'],
                                  userData: isInList.userDetails,
                                  sDate: selectedDate);
                              print(_allDetailsList);
                              try {
                                await oderManage.saveOrder(_allDetailsList);
                                sendAndRetrieveMessage(
                                    'Sav Admin',
                                    'There is a new Order for date ${selectedDate.toString().substring(0, 10)}',
                                    'admin');
                                Provider.of<IsInList>(context, listen: false)
                                    .removeAllDetails();

                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                  return SuccessfulPage();
                                }, transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                  var begin = Offset(1.0, 0.0);
                                  var end = Offset(0.0, 0.0);
                                  var tween = Tween(begin: begin, end: end);
                                  var offsetAnimation = animation.drive(tween);
                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                }));
                              } catch (e) {
                                print("error $e");
                              }

                              _showSpinner = false;
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            color: Color(0xff36b58b),
                            alignment: Alignment.center,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Place Order',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Update the app to Continue',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Material(
                              elevation: 4,
                              // color: Color(0xff36b58b),
                              child: InkWell(
                                onTap: () {
                                  // print(snapshot.data['link']);
                                  _launchURL(snapshot.data['link']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        child:
                                            Image.asset('assets/playstore.png'),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Update App',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
