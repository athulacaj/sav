import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';

import 'cartDatabase.dart';
import 'orderSucessFulPage.dart';

class DeliverySlot extends StatefulWidget {
  @override
  _DeliverySlotState createState() => _DeliverySlotState();
}

class _DeliverySlotState extends State<DeliverySlot> {
  int selected = -1;
  DateTime _whichDay;
  DateTime selectedDate;
  @override
  void initState() {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff36b58b),
        title: Text('Select Delivery Date'),
      ),
      body: Column(
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
              selectedDate = new DateTime(now.year, now.month, now.day + 1);

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
              if (selectedDate != null) {
                print(selectedDate);
                // List userData =
                //     Provider.of<IsInList>(context, listen: false)
                //         .userDetails;
                OrderManage oderManage = OrderManage(
                    uid: isInList.userDetails['uid'],
                    userData: isInList.userDetails,
                    sDate: selectedDate);
                await oderManage.saveOrder(_allDetailsList);
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                  return SuccessfulPage();
                }, transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset(0.0, 0.0);
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                }));
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
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
