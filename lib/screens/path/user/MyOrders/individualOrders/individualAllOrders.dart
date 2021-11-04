import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sav/functions/showToastFunction.dart';
import 'package:sav/screens/path/user/MyOrders/timeComparison.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sav/functions/quantityFormat.dart';
import 'package:sav/providers/provider.dart';

import 'rating.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List _orders = [];
bool isOrderConfirmed = false;

class IndividualOrders extends StatefulWidget {
  final List? allDetails;
  final Map? allData;
  final String? pvsDocId;
  IndividualOrders({this.allDetails, this.allData, this.pvsDocId});
  @override
  _IndividualOrdersState createState() => _IndividualOrdersState();
}

class _IndividualOrdersState extends State<IndividualOrders> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  int reviewNo = 0;
  bool _showSpinner = false;
  late String status;
  @override
  void initState() {
    isOrderConfirmed = false;
    reviewNo = 0;
    super.initState();
    _showSpinner = false;
    status = widget.allData!['status'];
  }

  @override
  Widget build(BuildContext context) {
    var user =
        Provider.of<IsInListProvider>(context, listen: false).userDetails;

    int _nowInMS = DateTime.now().millisecondsSinceEpoch;
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: Color(0xff36b58b),
          title: Text('Order details '),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'status : $status',
                        style: TextStyle(
                            color: status == 'canceled'
                                ? Colors.grey
                                : status == 'delivered'
                                    ? Colors.green
                                    : Color(0xff36b58b)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 1000),
                  child: ListView.builder(
                    itemCount: widget.allDetails!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      Map detials = widget.allDetails![index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text('${detials['name']}'),
                              Spacer(),
                              Text('${detials['quantity']} kg'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       Text('Total Quantity'),
                //       Spacer(),
                //       Text('${totalQuantity(widget.allDetails!)} kg'),
                //     ],
                //   ),
                // ),
                SizedBox(height: 35),
                widget.allData!['status'] == 'ordered'
                    ? FlatButton(
                        color: Colors.grey.shade700,
                        child: Container(
                          child: Text(
                            'Cancel Order',
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                        onPressed: () async {
                          DateTime? deliveryDate =
                              widget.allData!['time'].toDate();
                          String ymd = '$deliveryDate'.substring(0, 10);
                          String id = '${user!['uid']}!${widget.pvsDocId}';
                          print(id);

                          showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    'Are you sure you want to cancel the items?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.pop(context, 'cancel');
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () async {
                                      Navigator.pop(context, 'remove');
                                      _showSpinner = true;
                                      setState(() {});
                                      await _firestore
                                          .collection(
                                              'orders/by/${user['uid']}')
                                          .doc(widget.pvsDocId!)
                                          .update({'status': 'canceled'});
                                      await _firestore
                                          .collection('orders/byTime/$ymd')
                                          .doc(id)
                                          .update({'status': 'canceled'});
                                      status = 'canceled';
                                      _showSpinner = false;
                                      setState(() {});
                                      showToast("Canceled ");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    : Container(),
                SizedBox(height: 15),
                FlatButton(
                    color: Colors.greenAccent,
                    onPressed: () {
                      IsInListProvider isInListProvider =
                          Provider.of<IsInListProvider>(context, listen: false);
                      isInListProvider.fromOrdersToCart(widget.allDetails!);
                      print(widget.allData!['userData']);
                      isInListProvider.addUser(widget.allData!['userData']);
                      showToast(
                          "${widget.allDetails!.length} Items Added to cart");
                    },
                    child: Text("Add to cart"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//

launchCaller(String phoneNo) async {
  var _url = "tel:$phoneNo";
  if (await canLaunch(_url)) {
    await launch(_url);
  } else {
    throw 'Could not launch $_url';
  }
}

String timeConvertor(Timestamp time) {
  DateTime givenDay = time.toDate();
  int day = givenDay.day;
  int month = givenDay.month;
  int year = givenDay.year;
  return "$day-$month-$year";
}

double totalQuantity(List details) {
  double totalQ = 0;
  for (Map data in details) {
    totalQ = totalQ + data['quantity'];
  }
  return totalQ;
}
