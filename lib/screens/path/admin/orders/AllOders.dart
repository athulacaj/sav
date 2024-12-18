import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sav/functions/duplicateOrdersFinder.dart';
import 'package:sav/functions/showMaterialBanner.dart';
import 'package:sav/providers/allOrdersProvider.dart';
import 'package:sav/screens/path/admin/individualOrders/individualOrders.dart';
import 'package:sav/screens/path/admin/individualOrders/timeComparison.dart';
import 'package:sav/screens/path/admin/print/mutipleThermalPrint.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'tableView.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List _orders = [];
List<DocumentSnapshot<Map<String, dynamic>>> _allOrdersFiltered = [];
late DateTime _whichDay;
List whichTypeList = ['all', 'ordered', 'canceled', 'delivered'];
List areaList = ['all'];
List<int> selectedList = [];
bool showPrintOption = false;

class AllOrders extends StatefulWidget {
  final List areaList;
  AllOrders({required this.areaList});
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

String _whichType = 'all';
String _area = 'all';
String _whichAdmin = 'all';
bool showDuplicateBanner = true;

class _AllOrdersState extends State<AllOrders> {
  @override
  void initState() {
    showPrintOption = false;
    areaList = widget.areaList;
    _whichDay = DateTime.now();
    showDuplicateBanner = true;
    super.initState();
    reset();
  }

  void reset() {
    _whichType = 'all';
    _whichAdmin = 'all';
    selectedList = [];
    _allOrders = [];
  }

  List<DocumentSnapshot<Map<String, dynamic>>> _allOrders = [];

  Future<Null> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _whichDay,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(now.year, now.month + 1, now.day - 1));
    if (picked != null && picked != _whichDay) _whichDay = picked;
    print('date changed');
    reset();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map adminData =
        Provider.of<IsInListProvider>(context, listen: false).userDetails!;
    print(adminData['uid']);
    print('uid');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff36b58b),
        title: Text('All orders'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _whichDay = _whichDay.subtract(Duration(days: 1));
                selectedList = [];
                reset();
                setState(() {});
              },
              icon: Icon(Icons.arrow_back_ios)),
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
          IconButton(
              onPressed: () {
                _whichDay = _whichDay.add(Duration(days: 1));
                reset();
                setState(() {});
              },
              icon: Icon(Icons.arrow_forward_ios)),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection(
                'orders/byTime/${_whichDay.toString().substring(0, 10)}')
            .orderBy("time", descending: true)
            // .where('uid', isEqualTo: adminData['uid'])
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
          _allOrders = snapshot.data!.docs;

          // AllOrdersProvider.setFilteredOrdersList(_allOrders);
          // Provider.of(context, listen: false)
          //     .filterOrder(_whichType, _allOrders);
          return Consumer<AllOrdersProvider>(
            builder: (context, AllOrdersProvider allOrdersProvider, child) {
              allOrdersProvider.filterOrder(_whichType, _allOrders, false);
              _allOrdersFiltered = allOrdersProvider.getFilteredOrdersList();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    // admin list
                    // StreamBuilder(
                    //     stream: _firestore
                    //         .collection('users')
                    //         .where('isAdmin', isEqualTo: true)
                    //         // .orderBy('time', descending: true)
                    //         .snapshots(),
                    //     builder: (context,
                    //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    //             snapshot) {
                    //       if (!snapshot.hasData) {
                    //         return Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       }
                    //       if (snapshot.hasData == false) {
                    //         return Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       }
                    //       List adminsList = snapshot.data!.docs;
                    //       AllOrdersProvider.adminsList = adminsList;
                    //       return SizedBox(
                    //         height: 50,
                    //         child: ListView.builder(
                    //           itemCount: adminsList.length,
                    //           scrollDirection: Axis.horizontal,
                    //           itemBuilder: (BuildContext context, int i) {
                    //             return filterButton(
                    //                 adminsList[i], allOrdersProvider);
                    //           },
                    //         ),
                    //       );
                    //     }),
                    // area list
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: areaList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int i) {
                          return areaFilterButton(
                              areaList[i], allOrdersProvider);
                        },
                      ),
                    ),
                    showDuplicateBanner && _whichAdmin.toLowerCase() == 'all'
                        ? Container(
                            width: size.width,
                            color: Colors.orangeAccent.withOpacity(.3),
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Duplicate Orders",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          showDuplicateBanner = false;
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.close)),
                                  ],
                                ),
                                Divider(),
                                Text(
                                    DuplicateOrderFinder.find(
                                      _allOrders,
                                    ),
                                    style:
                                        TextStyle(height: 1.5, fontSize: 16)),
                              ],
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        itemCount: _allOrdersFiltered.length,
                        itemBuilder: (context, index) {
                          String? status =
                              _allOrdersFiltered[index].data()!['status'];
                          var orderedTime =
                              _allOrdersFiltered[index].data()!['time'];
                          Timestamp? deliveredTime = _allOrdersFiltered[index]
                                  .data()!['deliveredTime'] ??
                              null;

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
                    selectedList.length >= 1
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
                                    selectedList = [];

                                    for (int i = 0;
                                        i < _allOrdersFiltered.length;
                                        i++) {
                                      int refNo = _allOrdersFiltered.length - i;
                                      if (_allOrdersFiltered[i]
                                              .data()!['status'] !=
                                          'canceled') {
                                        selectedList.add(refNo);
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
                                    selectedList = [];
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
                                    for (int refNo in selectedList) {
                                      int index =
                                          _allOrdersFiltered.length - refNo;
                                      itemsToPrint
                                          .add(_allOrdersFiltered[index]);
                                    }
                                    print(itemsToPrint.length);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MultipleThermalPrint(
                                                    itemsToPrint,
                                                    selectedList)));
                                  },
                                ),
                                Text("${selectedList.length}",
                                    style: TextStyle(color: Colors.white)),
                                Spacer(),
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_circle_up,
          color: Colors.white,
        ),
        onPressed: () {
          showTableBottomSheet(context, _allOrdersFiltered, _whichAdmin);
        },
      ),
    );
//          StreamBuilder<QuerySnapshot>(
  }

  Widget filterButton(
      DocumentSnapshot data, AllOrdersProvider allOrdersProvider) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        elevation: 4,
        child: InkWell(
          onTap: () {
            _whichType = data['uid'];
            _whichAdmin = data['name'];
            allOrdersProvider.filterOrder(_whichType, _allOrders, true);
            selectedList = [];
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 70),
            child: Container(
                color: _whichType == data['uid']
                    ? Colors.greenAccent
                    : Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.all(6),
                child: Text("${data['name']}")),
          ),
        ),
      ),
    );
  }

  Widget areaFilterButton(String area, AllOrdersProvider allOrdersProvider) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        elevation: 4,
        child: InkWell(
          onTap: () {
            _area = area;
            allOrdersProvider.filterBaseOnArea(_area, true);
            selectedList = [];
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 70),
            child: Container(
                color: _area == area ? Colors.greenAccent : Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.all(6),
                child: Text(area)),
          ),
        ),
      ),
    );
  }
}

int odersCountByStatus(String status, List allOrders) {
  int count = 0;
  if (status == 'all') {
    return count = allOrders.length;
  }
  for (DocumentSnapshot<Map<String, dynamic>> orders in allOrders) {
    String? ostatus = orders.data()!['status'];
    if (status == ostatus) {
      count++;
    }
  }
  print('count $count');
  return count;
}

class ExtractedAllOrdersContainer extends StatefulWidget {
  final int? index;
  final String? status;
  final orderedTime;
  final deliveredTime;
  final int? totalOrders;
  final Map? allData;
  final Function? callback;
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
    int refNo = _allOrdersFiltered.length - widget.index!;
    final DateFormat formatter = DateFormat();
    DateTime orderedTime = (widget.orderedTime as Timestamp).toDate();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onLongPress: () {
          if (selectedList.contains(refNo)) {
            // selected.remove(refNo);
          } else {
            widget.status != 'canceled' ? selectedList.add(refNo) : null;
          }
          print('selected ${selectedList.contains(refNo)}');
          widget.callback!();
          // setState(() {});
        },
        onTap: () {
          if (selectedList.isNotEmpty) {
            if (selectedList.contains(refNo)) {
              selectedList.remove(refNo);
            } else {
              widget.status != 'canceled' ? selectedList.add(refNo) : null;
            }
            // setState(() {});
            widget.callback!();
          } else {
            print("id is ${_allOrdersFiltered[widget.index!].id}");
            print("id is ${_allOrdersFiltered[widget.index!]['docId']}");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndividualOrders(
                          uid:
                              '${_allOrdersFiltered[widget.index!].data()!['userData']['uid']}',
                          orderedTimeFrmPrvsScreen: widget.orderedTime,
                          orderNumber: widget.totalOrders! - widget.index!,
                          bytimeId: _allOrdersFiltered[widget.index!].id,
                          allData: widget.allData,
                          refNo: _allOrdersFiltered.length - widget.index!,
                          IndividualID: _allOrdersFiltered[widget.index!]
                              ['docId'],
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
                              '${_allOrdersFiltered.length - widget.index!}',
                              style: TextStyle(color: Colors.white),
                            ))),
                    SizedBox(width: 6),
                    Expanded(
                        child: Text(
                            '${_allOrdersFiltered[widget.index!].data()!['userData']['name']} ,  ${_allOrdersFiltered[widget.index!].data()!['userData']['shopName']}')),
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
                        'Ordered: ${formatter.format(orderedTime)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            fontSize: 11),
                      ),
                    ),
                    widget.deliveredTime != null
                        ? Expanded(
                            child: Text(
                              'Delivered:${timeConvertor(_nowInMS - widget.deliveredTime.millisecondsSinceEpoch, widget.deliveredTime)}',
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
                color: selectedList.contains(refNo) == true
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
