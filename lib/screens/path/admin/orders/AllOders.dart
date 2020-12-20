import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sav/screens/path/admin/individualOrders/individualOrders.dart';
import 'package:sav/screens/path/admin/individualOrders/timeComparison.dart';
import 'package:sav/screens/path/admin/print/mutipleThermalPrint.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'tableView.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List _orders = [];
List<DocumentSnapshot> _allOrdersFiltered = [];
List<DocumentSnapshot> _allOrders;
var _whichDay;
String _whichType = 'all';
List whichTypeList = ['all', 'ordered', 'canceled', 'delivered'];
List<int> selected = [];
bool showPrintOption = false;

class AllOrders extends StatefulWidget {
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  @override
  void initState() {
    showPrintOption = false;
    selected = [];
    _whichType = 'all';
    _whichDay = DateTime.now();
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _whichDay,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(now.year, now.month + 1, now.day - 1));
    if (picked != null && picked != _whichDay) _whichDay = picked;
    print('date changed');
    setState(() {});
    callSetStateWIthDelay();
  }

  DateTime _today = DateTime.now();
  String toYesterday(DateTime now) {
    final lastMidnight = new DateTime(now.year, now.month + 1, now.day - 1);
    return lastMidnight.toLocal().toString().split(' ')[0];
  }

  void callSetStateWIthDelay() async {
    await Future.delayed(Duration(milliseconds: 400));
    setState(() {});
  }

  List filterOrder(String whichType, List allOrders) {
    if (whichType == 'all') {
      return allOrders;
    }
    return allOrders
        .where((value) => value.data()['status'] == whichType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map adminData = Provider.of<IsInList>(context, listen: false).userDetails;
    print(adminData['uid']);
    print('uid');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff36b58b),
        title: Text('All orders'),
        actions: <Widget>[
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "${_whichDay.toLocal()}".split(' ')[0],
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
              height: double.infinity,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection(
                'orders/byTime/${_whichDay.toString().substring(0, 10)}')
            .where('uid', isEqualTo: adminData['uid'])
            // .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // _allOrders = snapshot.data.documents;
          _allOrders = snapshot.data.documents.reversed.toList();
          print(snapshot.data.documents);
          _allOrdersFiltered = filterOrder(_whichType, _allOrders);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    itemCount: _allOrdersFiltered.length,
                    itemBuilder: (context, index) {
                      String status =
                          _allOrdersFiltered[index].data()['status'];
                      var orderedTime =
                          _allOrdersFiltered[index].data()['time'];
                      Timestamp deliveredTime =
                          _allOrdersFiltered[index].data()['deliveredTime'] ??
                              null;
                      Map boyDetails =
                          _allOrdersFiltered[index].data()['boyDetails'];

                      return ExtractedAllOrdersContainer(
                        index: index,
                        status: status,
                        orderedTime: orderedTime,
                        deliveredTime: deliveredTime,
                        totalOrders: _allOrdersFiltered.length,
                        allData: _allOrdersFiltered[index].data(),
                        callback: () {
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
                selected.length >= 1
                    ? Container(
                        width: size.width,
                        color: Colors.blue.withOpacity(0.75),
                        padding: EdgeInsets.all(6),
                        height: 60,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.select_all,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                selected = [];

                                for (int i = 0;
                                    i < _allOrdersFiltered.length;
                                    i++) {
                                  int refNo = _allOrdersFiltered.length - i;
                                  if (_allOrdersFiltered[i].data()['status'] !=
                                      'canceled') {
                                    selected.add(refNo);
                                  }
                                }
                                setState(() {});
                              },
                            ),
                            SizedBox(width: 35),
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                selected = [];
                                setState(() {});
                              },
                            ),
                            SizedBox(width: 35),
                            IconButton(
                              icon: Icon(
                                Icons.print,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                List<DocumentSnapshot> itemsToPrint = [];
                                for (int refNo in selected) {
                                  int index = _allOrdersFiltered.length - refNo;
                                  itemsToPrint.add(_allOrdersFiltered[index]);
                                }
                                print(_allOrdersFiltered[0].id);

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (BuildContext context) =>
                                //             MutipleThermalPrint(
                                //                 itemsToPrint, selected)));
                              },
                            ),
                            Spacer(),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_circle_up,
          color: Colors.white,
        ),
        onPressed: () {
          showTableBottomSheet(context, _allOrdersFiltered);
        },
      ),
    );
//          StreamBuilder<QuerySnapshot>(
  }
}

int odersCountByStatus(String status, List allOrders) {
  int count = 0;
  if (status == 'all') {
    return count = allOrders.length;
  }
  for (DocumentSnapshot orders in allOrders) {
    String ostatus = orders.data()['status'];
    if (status == ostatus) {
      count++;
    }
  }
  print('count $count');
  return count;
}

class ExtractedAllOrdersContainer extends StatefulWidget {
  final int index;
  final String status;
  final orderedTime;
  final deliveredTime;
  final int totalOrders;
  final Map allData;
  final Function callback;
  ExtractedAllOrdersContainer(
      {this.index,
      this.status,
      this.orderedTime,
      this.deliveredTime,
      this.allData,
      this.totalOrders,
      this.callback});

  @override
  _ExtractedAllOrdersContainerState createState() =>
      _ExtractedAllOrdersContainerState();
}

class _ExtractedAllOrdersContainerState
    extends State<ExtractedAllOrdersContainer> {
  @override
  Widget build(BuildContext context) {
    int _nowInMS = DateTime.now().millisecondsSinceEpoch;
    int refNo = _allOrders.length - widget.index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onLongPress: () {
          if (selected.contains(refNo)) {
            // selected.remove(refNo);
          } else {
            widget.status != 'canceled' ? selected.add(refNo) : null;
          }
          print('selected ${selected.contains(refNo)}');
          widget.callback();
          // setState(() {});
        },
        onTap: () {
          if (selected.isNotEmpty) {
            if (selected.contains(refNo)) {
              selected.remove(refNo);
            } else {
              widget.status != 'canceled' ? selected.add(refNo) : null;
            }
            // setState(() {});
            widget.callback();
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndividualOrders(
                          uid:
                              '${_allOrders[widget.index].data()['userData']['uid']}',
                          orderedTimeFrmPrvsScreen: widget.orderedTime,
                          orderNumber: widget.totalOrders - widget.index,
                          bytimeId: _allOrders[widget.index].id,
                          allData: widget.allData,
                          refNo: _allOrders.length - widget.index,
                          id: _allOrders[widget.index].data()['docId'],
                        )));
          }
        },
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    // toAdd['refNo'] = allOrders.length - i;

                    Material(
                        elevation: 4,
                        child: Container(
                            color: widget.status == 'ordered'
                                ? Colors.blueAccent
                                : widget.status == 'delivered'
                                    ? widget.status == 'shipped'
                                        ? Colors.orange
                                        : Colors.green
                                    : widget.status == 'canceled'
                                        ? Colors.grey
                                        : Colors.orange,
                            padding: EdgeInsets.all(4),
                            width: 40,
                            alignment: Alignment.centerLeft,
                            height: 30,
                            child: Text(
                              '${_allOrders.length - widget.index}',
                              style: TextStyle(color: Colors.white),
                            ))),
                    SizedBox(width: 6),
                    Expanded(
                        child: Text(
                            '${_allOrders[widget.index].data()['userData']['name']} ,  ${_allOrders[widget.index].data()['userData']['shopName']}')),
                    Text(widget.status ?? '',
                        style: TextStyle(
                            fontSize: 12,
                            color: widget.status == 'ordered'
                                ? Colors.purple
                                : widget.status == 'delivered'
                                    ? widget.status == 'shipped'
                                        ? Colors.orange
                                        : Colors.green
                                    : widget.status == 'canceled'
                                        ? Colors.grey
                                        : Colors.orange)),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Ordered: ${timeConvertor(_nowInMS - widget.orderedTime.millisecondsSinceEpoch, widget.orderedTime) ?? ''}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            fontSize: 11),
                      ),
                    ),
                    widget.deliveredTime != null
                        ? Expanded(
                            child: Text(
                              'Delivered:${timeConvertor(_nowInMS - widget.deliveredTime.millisecondsSinceEpoch, widget.deliveredTime) ?? ''}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 11),
                            ),
                          )
                        : Container(),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
                color: selected.contains(refNo) == true
                    ? Colors.yellow
                    : Colors.white,
                border: Border.all(
                    color: widget.status == 'ordered'
                        ? Colors.purple
                        : widget.status == 'delivered'
                            ? widget.status == 'shipped'
                                ? Colors.orange
                                : Colors.green
                            : widget.status == 'canceled'
                                ? Colors.grey
                                : Colors.orange,
                    width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
      ),
    );
  }
}
