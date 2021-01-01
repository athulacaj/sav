import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'individualOrders/individualAllOrders.dart';
import 'package:sav/extracted/commonAppBar.dart';
import 'package:sav/functions/quantityFormat.dart';
import 'timeComparison.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List _orders = [];

class MyOrders extends StatefulWidget {
  static String id = 'MyOrders';

  String fromWhere;
  MyOrders({this.fromWhere});
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  void initState() {
    _orders = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<IsInList>(context, listen: false).userDetails;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: widget.fromWhere == null
          ? () {
              if (widget.fromWhere == null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'Home_Screen', (Route<dynamic> route) => false);
              }
              return new Future(() => false);
            }
          : null,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CommonAppbar(
              title: 'My Orders',
              whichScreen: widget.fromWhere == null ? 'MyOrders' : '',
            ),
            user == null
                ? Container()
                : StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('orders/by/${user['uid']}')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: size.height - 74,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      }
                      print('updated');
                      var _details = snapshot.data.docs;
                      _orders = [];
                      int _nowInMS = DateTime.now().millisecondsSinceEpoch;
                      DateTime now = DateTime.now();
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int i) {
                            Map allData = snapshot.data.docs[i].data();
                            DateTime time = allData['time'].toDate();

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 4,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  height: 91,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'status : ${allData['status']}',
                                            style: TextStyle(
                                                color: allData['status'] ==
                                                        'canceled'
                                                    ? Colors.grey
                                                    : allData['status'] ==
                                                            'delivered'
                                                        ? Colors.green
                                                        : Color(0xff36b58b)),
                                          ),
                                          Spacer(),
                                          Text(
                                              'Delivery Date: ${timeConvertor(allData['time'])}'),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Text(
                                              'Total Quantity : ${totalQuantity(allData['details'])} kg'),
                                          Spacer(),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (contetx) =>
                                                          IndividualOrders(
                                                            allDetails: allData[
                                                                'details'],
                                                            allData: allData,
                                                            pvsDocId: snapshot
                                                                .data
                                                                .docs[i]
                                                                .id,
                                                          )));
                                            },
                                            child: Text('view more'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
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
