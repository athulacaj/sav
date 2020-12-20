import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sav/functions/quantityFormat.dart';
import 'package:sav/screens/path/admin/functions/sendFcm.dart';
import 'timeComparison.dart';
import 'package:sav/screens/path/admin/print/thermalPrint.dart';

String _whichType = 'all';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List _orders = [];
bool isDataAvailable = false;
List<DocumentSnapshot> _details = [];
List<Widget> columWidget = [];

class IndividualOrders extends StatefulWidget {
  final String uid;
  final orderedTimeFrmPrvsScreen;
  final orderNumber;
  final String bytimeId;
  final String id;
  final Map allData;
  final refNo;
  IndividualOrders(
      {this.uid,
      this.orderedTimeFrmPrvsScreen,
      this.orderNumber,
      this.refNo,
      this.id,
      @required this.allData,
      this.bytimeId});
  @override
  _IndividualOrdersState createState() => _IndividualOrdersState();
}

class _IndividualOrdersState extends State<IndividualOrders> {
  @override
  void initState() {
    _whichType = 'Order';
    columWidget = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff36b58b),
        title: Text('Individual Orders'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('orders/by/${widget.uid}')
//                .where('status', isEqualTo: '$_whichType')
                .doc(widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _details = [snapshot.data];
                print(snapshot.data['details']);
              } else {
                _details = [];
              }
              _orders = [];
              int _nowInMS = DateTime.now().millisecondsSinceEpoch;
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return Expanded(
                child: ListView.builder(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 8),
                  itemCount: _details.length,
                  itemBuilder: (BuildContext context, int index) {
                    List ordersList = _details[index].data()['details'];
                    Timestamp orderedTime = _details[index].data()['time'];
                    Timestamp deliveredTime =
                        _details[index].data()['deliveredTime'] ?? null;
                    var _deliverySolot = _details[index].data()['deliverySlot'];
                    // String fcmId = _details[index].data()['fcmId'];
                    String status = _details[index].data()['status'];

                    String _documentId = (_details[index].id);
                    int total = 0;
                    columWidget = [];
                    for (Map individualorder in ordersList) {
                      total = individualorder['amount'] + total;
                      Widget toAdd = Padding(
                        padding: const EdgeInsets.only(
                            left: 0, top: 6, bottom: 6, right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
//                            SizedBox(width: 8),
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        text: '${individualorder['name']} ',
                                        children: [
                                          individualorder['shopName'] != null
                                              ? TextSpan(
                                                  text: '( ' +
                                                      individualorder[
                                                          'shopName'] +
                                                      ' )',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey),
                                                )
                                              : TextSpan(),
                                        ]),
                                  ),
                                  flex: 2,
                                ),
                              ],
                            )),
                            SizedBox(width: 8),
                            Text('${individualorder['quantity']} kg'),
                          ],
                        ),
                      );
                      if (_whichType == 'Order') {
                        print('order');
                        if (widget.orderedTimeFrmPrvsScreen == orderedTime) {
                          columWidget.add(toAdd);
                        }
                      } else if (status == _whichType) {
                        columWidget.add(toAdd);
                      } else if (_whichType == 'all') {
                        print('all order');
                        columWidget.add(toAdd);
                      }
                    }
                    bool _isOrderedToday =
                        orderedTime.toDate().toString().substring(0, 10) ==
                            DateTime.now().toString().substring(0, 10);
                    return columWidget.length <= 0
                        ? Container()
                        : Container(
                            padding: EdgeInsets.all(4),
                            margin: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: status == 'ordered'
                                      ? Colors.purple
                                      : status == 'delivered'
                                          ? status == 'shipped'
                                              ? Colors.orange
                                              : Colors.green
                                          : status == 'canceled'
                                              ? Colors.grey
                                              : Colors.orange,
                                )),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 4),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Ordered: ${timeConvertor(_nowInMS - orderedTime.millisecondsSinceEpoch, orderedTime)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                              fontSize: 11),
                                        ),
                                      ),
                                      deliveredTime != null
                                          ? Expanded(
                                              child: Text(
                                                'Delivered:${timeConvertor(_nowInMS - deliveredTime.millisecondsSinceEpoch, deliveredTime)}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey,
                                                    fontSize: 11),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Material(
                                  elevation: 3,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Column(
                                          children: columWidget,
                                        ),
                                        SizedBox(height: 6),
                                        // deliveryFee
                                        Row(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  status ?? 'nill',
                                                  style: TextStyle(
                                                      color: status == 'ordered'
                                                          ? Colors.purple
                                                          : status ==
                                                                  'delivered'
                                                              ? status ==
                                                                      'shipped'
                                                                  ? Colors
                                                                      .orange
                                                                  : Colors.green
                                                              : status ==
                                                                      'canceled'
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .orange),
                                                ),
                                                SizedBox(width: 2),
                                                status == 'ordered'
                                                    ? Icon(
                                                        Icons
                                                            .playlist_add_check,
                                                        color: Colors.purple)
                                                    : status == 'canceled'
                                                        ? Icon(
                                                            Icons.close,
                                                            color: Colors.grey,
                                                          )
                                                        : Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                              ],
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                        SizedBox(height: 18),
                                        SizedBox(height: 18),
                                        // Text(
                                        //   '$_deliverySolot',
                                        //   style: TextStyle(
                                        //       fontSize: 16,
                                        //       color: Colors.blue,
                                        //       fontWeight: FontWeight.w600),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                SizedBox(height: 8),
                                SizedBox(height: 5),
                                FlatButton(
                                  child: Text(
                                    status == 'delivered'
                                        ? 'Convert to Ordered'
                                        : status == 'canceled'
                                            ? 'Make Ordered'
                                            : 'Make Delivered',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                  onPressed: () async {
                                    if (status == 'ordered' ||
                                        status == 'shipped' ||
                                        status == 'confirmed') {
                                      await _firestore
                                          .collection('orders/by/${widget.uid}')
                                          .doc(_documentId)
                                          .update({
                                        'status': 'delivered',
                                        'deliveredTime': DateTime.now(),
                                      });
//
                                      await _firestore
                                          .collection(
                                              'orders/byTime/${orderedTime.toDate().toString().substring(0, 10)}')
                                          .doc(widget.bytimeId)
                                          .update({
                                        'status': 'delivered',
                                        'deliveredTime': DateTime.now(),
                                      });
                                    }
                                    if (status == 'delivered' ||
                                        status == 'canceled') {
                                      _firestore
                                          .collection('orders/by/${widget.uid}')
                                          .doc(_documentId)
                                          .update({
                                        'deliveredTime': null,
                                        'status': 'ordered'
                                      });
                                      await _firestore
                                          .collection(
                                              'orders/byTime/${orderedTime.toDate().toString().substring(0, 10)}')
                                          .doc(widget.bytimeId)
                                          .update({
                                        'status': 'ordered',
                                        'deliveredTime': null,
                                      });
                                    }
                                  },
                                  color: status == 'ordered'
                                      ? Colors.green
                                      : status == 'canceled'
                                          ? Colors.grey
                                          : Color(0xff36b58b),
                                ),
                                FlatButton(
                                  child: Text(
                                    "Confirmed",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                  onPressed: () async {
                                    _firestore
                                        .collection('orders/by/${widget.uid}')
                                        .doc(_documentId)
                                        .update({
                                      'deliveredTime': null,
                                      'status': 'confirmed'
                                    });
                                    await _firestore
                                        .collection(
                                            'orders/byTime/${orderedTime.toDate().toString().substring(0, 10)}')
                                        .doc(widget.bytimeId)
                                        .update({
                                      'status': 'confirmed',
                                      'deliveredTime': null,
                                    });
                                  },
                                  color: status == 'canceled'
                                      ? Colors.grey
                                      : Color(0xff36b58b),
                                ),
                                FlatButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                  onPressed: () async {
                                    _firestore
                                        .collection('orders/by/${widget.uid}')
                                        .doc(_documentId)
                                        .update({
                                      'deliveredTime': null,
                                      'status': 'canceled'
                                    });
                                    await _firestore
                                        .collection(
                                            'orders/byTime/${orderedTime.toDate().toString().substring(0, 10)}')
                                        .doc(widget.bytimeId)
                                        .update({
                                      'status': 'canceled',
                                      'deliveredTime': null,
                                    });
                                  },
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 5),
                                SizedBox(height: 18),
                              ],
                            ),
                          );
                  },
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () async {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) => ThermalPrint(
              //               widget.allData['details'],
              //               widget.allData,
              //               widget.refNo,
              //             )));
            },
            child: Container(
              padding: EdgeInsets.all(8),
              height: 50,
              color: Color(0xff36b58b),
              alignment: Alignment.center,
              width: size.width,
              child: Text(
                'Print',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
