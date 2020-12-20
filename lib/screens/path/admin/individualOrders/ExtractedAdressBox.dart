import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//class AddressBox extends StatelessWidget {
//  final int i;
//  final Function checkBoxFunction;
//  final Function deleteFunction;
//  final Function editAddress;
//  final Map details;
//  final int selectedIndex;
//  AddressBox(
//      {this.i,
//      this.editAddress,
//      this.checkBoxFunction,
//      this.details,
//      this.deleteFunction,
//      this.selectedIndex});
//
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: checkBoxFunction,
//      child: Container(
//        decoration: BoxDecoration(
//            color: Colors.white,
//            border: Border(
//                top: BorderSide(color: Colors.black.withOpacity(0.2)),
//                bottom: BorderSide(
//                  color: Colors.black.withOpacity(0.2),
//                ))),
//        child: AnimatedContainer(
//          duration: Duration(milliseconds: 200),
//          height: 150,
//          color: selectedIndex == i
//              ? Colors.purpleAccent.withOpacity(0.1)
//              : Colors.white,
//          child: Row(
//            children: <Widget>[
//              Expanded(
//                child: Padding(
//                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Row(
//                        children: <Widget>[
//                          Icon(
//                            details['type'] == 'Home'
//                                ? CupertinoIcons.home
//                                : details['type'] == 'Office'
//                                    ? Icons.work
//                                    : Icons.location_on,
//                          ),
//                          SizedBox(width: 5),
//                          Text(details['name']),
//                        ],
//                      ),
//                      Row(
//                        children: <Widget>[
//                          SizedBox(width: 29),
//                          AutoSizeText(
//                            '${details['houseName']}, ${details['city']}',
//                            maxLines: 1,
//                          ),
//                        ],
//                      ),
//                      Row(
//                        children: <Widget>[
//                          SizedBox(width: 29),
//                          Text(details['street']),
//                        ],
//                      ),
//                      Row(
//                        children: <Widget>[
//                          SizedBox(width: 29),
//                          Text(details['locality']),
//                        ],
//                      ),
//                      Row(
//                        children: <Widget>[
//                          SizedBox(width: 29),
//                          Text(details['pincode']),
//                        ],
//                      ),
//                      Row(
//                        children: <Widget>[
//                          GestureDetector(
//                            onTap: () {
//                              print('call');
////                              _launchCaller(9015);
//                            },
//                            child: Row(
//                              children: <Widget>[
//                                SizedBox(width: 29),
//                                Text(details['phone']),
//                              ],
//                            ),
//                          ),
//                        ],
//                      )
//                    ],
//                  ),
//                ),
//              ),
//              Container(
//                width: 60,
//                child: Column(
//                  children: <Widget>[
//                    Spacer(),
//                    GestureDetector(
//                      onTap: editAddress,
//                      child: Column(
//                        children: <Widget>[
//                          Icon(
//                            Icons.edit,
//                            color: Colors.black,
//                            size: 22,
//                          ),
//                          SizedBox(width: 10),
//                          Text('Edit', style: TextStyle(color: Colors.black)),
//                        ],
//                      ),
//                    ),
//                    Spacer(),
//                    GestureDetector(
//                      onTap: deleteFunction,
//                      child: Column(
//                        children: <Widget>[
//                          Icon(
//                            Icons.delete_outline,
//                            color: Colors.black,
//                            size: 22,
//                          ),
//                          Text('delete', style: TextStyle(color: Colors.black)),
//                        ],
//                      ),
//                    ),
//                    Spacer(),
//                  ],
//                ),
//                decoration: BoxDecoration(
//                    gradient: LinearGradient(
//                        begin: Alignment.topLeft,
//                        end: Alignment.topRight,
//                        colors: [
//                      Colors.white.withOpacity(0.4),
//                      Colors.white.withOpacity(0.6)
//                    ])),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}

class AddressBoxWithoutCheckbox extends StatelessWidget {
  final details;
  AddressBoxWithoutCheckbox({this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: Colors.black.withOpacity(0.1)),
              bottom: BorderSide(
                color: Colors.black.withOpacity(0.1),
              ))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        height: 160,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  details['type'] == 'Home'
                      ? CupertinoIcons.home
                      : details['type'] == 'Office'
                          ? Icons.work
                          : Icons.location_on,
                ),
                SizedBox(width: 5),
                Text(details['name']),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 29),
                Text('${details['houseName']}, ${details['city']}'),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 29),
                Text(details['street']),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 29),
                Text(details['locality']),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 29),
                Text(details['pincode']),
              ],
            ),
            GestureDetector(
              onTap: () {
                String _phoneString = details['phone'].toString().substring(3);
                int _phone = int.parse(_phoneString);
                print(_phone);
                _launchCaller(_phone);
              },
              child: Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 29),
                      Text(details['phone']),
                      SizedBox(width: 10),
                      Icon(
                        Icons.call,
                        size: 30,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_launchCaller(int phoneNo) async {
  var _url = "tel:$phoneNo";
  if (await canLaunch(_url)) {
    await launch(_url);
  } else {
    throw 'Could not launch $_url';
  }
}
