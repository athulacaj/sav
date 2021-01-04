import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sav/constants/constants.dart';
import 'package:sav/providers/provider.dart';
import 'package:sav/screens/authPage/phoneAuth/login.dart';
import 'package:sav/screens/path/user/MyOrders/MyOrders.dart';
import 'package:sav/firebaseMessaging.dart';

bool _showSPinner = false;

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<IsInList>(builder: (context, isInList, child) {
      Map _userDetails = isInList.userDetails;
      _showSPinner = isInList.showSpinner ?? false;
      return SafeArea(
        child: Drawer(
          child: SizedBox(
            height: 500,
            child: Column(
              children: <Widget>[
                _userDetails == null
                    ? Container(
                        height: 60,
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(),
                              flex: 3,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
//                                isInList.isShowSpinner(true);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhoneLoginScreen()));
                                },
                                child: Container(
//                                padding: EdgeInsets.symmetric(vertical: 6),
                                  height: 35,
                                  alignment: Alignment.center,
                                  child: _showSPinner == true
                                      ? Stack(
                                          children: <Widget>[
                                            SizedBox(
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.purple,
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.white),
                                              ),
                                              height: 20.0,
                                              width: 20.0,
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'Login',
                                          style: TextStyle(color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                  decoration:
                                      contaionerBlackOutlineButtonDecoration,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        height: 100,
                        padding: EdgeInsets.only(
                            left: 15, right: 8, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.person_pin,
                                        size: 25,
                                      ),
                                      SizedBox(width: 6),
                                      AutoSizeText(
                                        '${_userDetails['shopName']} shop',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  // await _auth.signOut();
                                  Provider.of<IsInList>(context, listen: false)
                                      .addUser(null);
                                  try {
                                    firebaseMessaging
                                        .unsubscribeFromTopic('admin');
                                  } catch (e) {}
                                },
                                child: Container(
                                  height: 35,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Log Out',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7)),
                                  ),
                                  decoration:
                                      contaionerBlackOutlineButtonDecoration,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyOrders(
                                  fromWhere: 'notnull',
                                )));
                  },
                  child: ListTile(
                    title: Text(
                      'My Orders',
                    ),
                    leading: Icon(Icons.shopping_cart, color: Colors.black),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 15.0, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
